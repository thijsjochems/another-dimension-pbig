import sys

def main():
    print("==========================================")
    print("   RFID SCANNER TOOL - DRUK OP CTRL+C OM TE STOPPEN")
    print("==========================================")
    print("Sluit de reader aan, klik in dit venster en scan een chip.\n")

    try:
        while True:
            # De reader 'typt' het nummer en drukt op Enter.
            # Python vangt dit op met de input() functie.
            rfid_code = input(">> WACHTEN OP SCAN... ")
            
            # Als er iets gescand is, printen we het duidelijk uit
            if rfid_code:
                print(f"--> GEVONDEN ID: '{rfid_code}'")
                print("-" * 30)
                
    except KeyboardInterrupt:
        print("\n\nScanner gestopt. Tot ziens!")
        sys.exit()

if __name__ == "__main__":
    main()