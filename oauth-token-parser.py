import json

def main():
    with open("oauth-token.json", "r") as f:
        data = json.load(f)
        f.close()
    with open("oauth-token.txt", "w") as f:
        f.write(data["access_token"])
        f.close()

if __name__ == "__main__":
    main()