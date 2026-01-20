#!/usr/bin/env python3
"""
Supabase MCP Server
Geeft toegang tot Supabase database via MCP protocol
"""

import asyncio
import os
import sys
from typing import Any
from pathlib import Path

# Load .env file
from dotenv import load_dotenv
load_dotenv()

from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import Tool, TextContent
from supabase import create_client, Client

# Initialiseer Supabase client
SUPABASE_URL = os.getenv("SUPABASE_URL")
SERVICE_ROLE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY") or os.getenv("SERVICE_ROLE_KEY")

if not SUPABASE_URL or not SERVICE_ROLE_KEY:
    print("ERROR: SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY must be set", file=sys.stderr)
    print(f"SUPABASE_URL: {SUPABASE_URL}", file=sys.stderr)
    print(f"SERVICE_ROLE_KEY: {SERVICE_ROLE_KEY[:20] if SERVICE_ROLE_KEY else 'None'}...", file=sys.stderr)
    sys.exit(1)

supabase: Client = create_client(SUPABASE_URL, SERVICE_ROLE_KEY)

# Define tools
TOOLS = [
    Tool(
        name="supabase_query",
        description="Execute a SELECT query on Supabase database. Returns JSON results.",
        inputSchema={
            "type": "object",
            "properties": {
                "table": {
                    "type": "string",
                    "description": "Table name to query"
                },
                "select": {
                    "type": "string",
                    "description": "Columns to select (default: '*')",
                    "default": "*"
                },
                "filters": {
                    "type": "object",
                    "description": "Filter conditions (e.g., {'id': 1, 'naam': 'test'})",
                    "default": {}
                },
                "limit": {
                    "type": "integer",
                    "description": "Limit number of results",
                    "default": 100
                }
            },
            "required": ["table"]
        }
    ),
    Tool(
        name="supabase_execute_sql",
        description="Execute raw SQL query on Supabase database. Use for INSERT, UPDATE, DELETE, or complex queries.",
        inputSchema={
            "type": "object",
            "properties": {
                "sql": {
                    "type": "string",
                    "description": "SQL query to execute"
                }
            },
            "required": ["sql"]
        }
    ),
    Tool(
        name="supabase_insert",
        description="Insert one or more records into a Supabase table.",
        inputSchema={
            "type": "object",
            "properties": {
                "table": {
                    "type": "string",
                    "description": "Table name"
                },
                "data": {
                    "type": "object",
                    "description": "Data to insert (single object or list of objects)"
                }
            },
            "required": ["table", "data"]
        }
    ),
    Tool(
        name="supabase_update",
        description="Update records in a Supabase table.",
        inputSchema={
            "type": "object",
            "properties": {
                "table": {
                    "type": "string",
                    "description": "Table name"
                },
                "data": {
                    "type": "object",
                    "description": "Data to update"
                },
                "filters": {
                    "type": "object",
                    "description": "Filter conditions (e.g., {'id': 1})"
                }
            },
            "required": ["table", "data", "filters"]
        }
    ),
    Tool(
        name="supabase_delete",
        description="Delete records from a Supabase table.",
        inputSchema={
            "type": "object",
            "properties": {
                "table": {
                    "type": "string",
                    "description": "Table name"
                },
                "filters": {
                    "type": "object",
                    "description": "Filter conditions (e.g., {'id': 1})"
                }
            },
            "required": ["table", "filters"]
        }
    )
]

async def handle_tool_call(name: str, arguments: dict[str, Any]) -> list[TextContent]:
    """Handle MCP tool calls"""
    
    try:
        if name == "supabase_query":
            table = arguments["table"]
            select = arguments.get("select", "*")
            filters = arguments.get("filters", {})
            limit = arguments.get("limit", 100)
            
            query = supabase.table(table).select(select)
            
            # Apply filters
            for key, value in filters.items():
                query = query.eq(key, value)
            
            # Apply limit
            query = query.limit(limit)
            
            response = query.execute()
            result = response.data
            
            return [TextContent(
                type="text",
                text=f"Query successful. Found {len(result)} records:\n\n{result}"
            )]
        
        elif name == "supabase_execute_sql":
            sql = arguments["sql"]
            response = supabase.rpc("exec_sql", {"query": sql}).execute()
            
            return [TextContent(
                type="text",
                text=f"SQL executed successfully:\n\n{response.data}"
            )]
        
        elif name == "supabase_insert":
            table = arguments["table"]
            data = arguments["data"]
            
            response = supabase.table(table).insert(data).execute()
            
            return [TextContent(
                type="text",
                text=f"Insert successful. Inserted {len(response.data)} record(s):\n\n{response.data}"
            )]
        
        elif name == "supabase_update":
            table = arguments["table"]
            data = arguments["data"]
            filters = arguments["filters"]
            
            query = supabase.table(table).update(data)
            
            for key, value in filters.items():
                query = query.eq(key, value)
            
            response = query.execute()
            
            return [TextContent(
                type="text",
                text=f"Update successful. Updated {len(response.data)} record(s):\n\n{response.data}"
            )]
        
        elif name == "supabase_delete":
            table = arguments["table"]
            filters = arguments["filters"]
            
            query = supabase.table(table).delete()
            
            for key, value in filters.items():
                query = query.eq(key, value)
            
            response = query.execute()
            
            return [TextContent(
                type="text",
                text=f"Delete successful. Deleted {len(response.data)} record(s):\n\n{response.data}"
            )]
        
        else:
            return [TextContent(
                type="text",
                text=f"Unknown tool: {name}"
            )]
    
    except Exception as e:
        return [TextContent(
            type="text",
            text=f"Error executing {name}: {str(e)}"
        )]

async def main():
    """Run the MCP server"""
    server = Server("supabase-mcp")
    
    @server.list_tools()
    async def list_tools():
        return TOOLS
    
    @server.call_tool()
    async def call_tool(name: str, arguments: Any):
        return await handle_tool_call(name, arguments)
    
    async with stdio_server() as (read_stream, write_stream):
        await server.run(read_stream, write_stream, server.create_initialization_options())

if __name__ == "__main__":
    asyncio.run(main())
