// import 'dart:convert';

const String testSignData = 'Test Web3Modal data';

String typeDataV4(int chainId) => '''
{
  "types": {
    "EIP712Domain":
      [
        {"type":"string","name":"name"},
        {"type":"string","name":"version"},
        {"type":"uint256","name":"chainId"},
        {"type":"address","name":"verifyingContract"}
      ],
    "Part":
      [
        {"name":"account","type":"address"},
        {"name":"value","type":"uint96"}
      ],
    "Mint721":
      [
        {"name":"tokenId","type":"uint256"},
        {"name":"tokenURI","type":"string"},
        {"name":"creators","type":"Part[]"},
        {"name":"royalties","type":"Part[]"}
      ]
  },
  "domain": {
    "name":"Mint721",
    "version":"1",
    "chainId": $chainId,
    "verifyingContract":"0x2547760120aed692eb19d22a5d9ccfe0f7872fce"
  },
  "primaryType":"Mint721",
  "message": {
    "@type":"ERC721",
    "contract":"0x2547760120aed692eb19d22a5d9ccfe0f7872fce",
    "tokenId":"1",
    "uri":"ipfs://ipfs/hash",
    "creators": [
      {"account":"0xc5eac3488524d577a1495492599e8013b1f91efa","value":10000}
    ],
    "royalties":[],
    "tokenURI":"ipfs://ipfs/hash"
  }
"royalties":[]
  }
}''';