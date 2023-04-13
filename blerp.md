# @DEV NOTES
>> Repeatable NFT Collection Steps
1. Generate NFT Art
    - Use hashlips to generate art: (1) download the haslips engine (2) install node_modules (!) these steps can be skipped if using template folder (3) edit the config file (4) add the layer images with correct labeling (5) 'node index.js' to generate 
        - how to guide: https://youtu.be/lFDpBmoD62A
        - code: https://github.com/HashLips/hashlips_art_engine
    - Upload IPFS and metadata: (1) create an api key on nft.storage and enter that into nftup (2) take the images folder from hashlips and drag and drop it into nftup (3) copy CID into hashlips config.js then run 'npx run update_info' (4) upload JSONs into nftup (5) copy CID and double check the files are linked correctly (**) if having issues running update script, try run via the packageJson
        - how to guide: https://youtu.be/_8c9FJ7W-jE
2. Write NFT Contracts
    - copy paste the base code
        - code: https://github.com/reecehunter/youtube/blob/main/contracts/simple-nft.sol
    - add additional functions
        - non erc2981 royalties
            - how to guide: https://youtu.be/dbmPkdMg_Fs
            - code: https://github.com/jklepatch/eattheblocks/blob/master/screencast/379-nft-royalties/contracts/NFT.sol
        - erc2981 royalties
            - how to guide 1: https://youtu.be/260NwFNGb8A?t=326
            - code 1: https://github.com/kennethhutw/EIP2981-implementation
            - how to guide 2 : https://youtu.be/h6Fb_dPZCd0
            - code 2: https://gist.github.com/shobhitic/50518080ca7cb29072d72730873ff54a

3. Deploy Contracts
    - Update variables; IPFS link, wallet addresses, xxx
    - Deploy code and verify
        - how to guide: https://youtu.be/cDZ0p5WTT3A?t=600
4. Integrate into HTML/JS/JSON page
    


# NOTES:
- https://nftstorage.link/ipfs/bafybeihscowmgmn6evsax36ys57hreo744vj5lgie3m6yjrb2u2vjufpiq
- forge test --fork-url https://polygon-mainnet.g.alchemy.com/v2/elpiyNU3HOchYaeMMpCteXolAFqJYTEi --match-path test/NFT.t.sol -vvv
