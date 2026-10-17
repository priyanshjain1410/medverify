# MedVerify – Fake Medicine Batch Verification DApp

**Course:** Blockchain Technology (CSE4444) – Assignment 2
**Status:** In progress (see [Project Status](#project-status))

## Problem Statement
Counterfeit, expired and recalled medicines are a serious public-health risk, and paper or centralised records are easy to forge. MedVerify stores medicine batch records on Ethereum so anyone can check whether a batch is **genuine, expired, recalled, or not registered (possible counterfeit)**.

**Roles**
| Role | Who | Can do |
|------|-----|--------|
| Regulator | Contract deployer | Authorise manufacturers, recall any batch |
| Manufacturer | Authorised by regulator | Register batches, recall own batches |
| Public | Anyone | Verify a batch (read-only) |

## Repository Structure
```
contracts/MedVerify.sol     Solidity smart contract
frontend/index.html         HTML + CSS + JavaScript UI (Ethers.js + MetaMask)
build/MedVerify.abi.json    Contract ABI
test-results.md             Local scripted test run (in-memory Ganache)
screenshots/                Evidence screenshots
```

## Smart Contract Summary
- **Constructor:** sets `regulator = msg.sender`
- **State:** `regulator`, `totalBatches`, `isManufacturer` mapping, `batches` mapping (drug name, manufacturer, expiry, recalled)
- **Functions:** `authoriseManufacturer`, `registerBatch`, `recallBatch`, `verifyBatch` (returns 0 = not found, 1 = genuine, 2 = expired, 3 = recalled)
- **Validation:** `onlyRegulator` / `onlyManufacturer` modifiers, non-empty inputs, unique batch ID, future expiry, no duplicate authorisation, recall permission check, zero-address check
- **Events:** `ManufacturerAuthorised`, `BatchRegistered`, `BatchRecalled`

## How to Run
1. Open [Remix IDE](https://remix.ethereum.org), add `contracts/MedVerify.sol`, compile with Solidity 0.8.20 or later.
2. Deploy from the **Deploy & Run** tab:
   - *Remix VM* for in-browser testing, or
   - *Injected Provider – MetaMask* for Sepolia / local Ganache.
3. Copy the deployed address into `CONTRACT_ADDRESS` in `frontend/index.html`.
4. Serve the frontend: `cd frontend && python -m http.server 8000`, then open `http://localhost:8000`.

## Connecting MetaMask
1. Install the MetaMask extension and create or import a test wallet (never use a wallet that holds real funds).
2. Select the same network the contract is deployed on (Sepolia, or a custom network for Ganache: RPC `http://127.0.0.1:8545`, Chain ID `1337`).
3. Open the app and click **Connect MetaMask**; approve the connection.
4. The page shows the connected account, regulator address, total batches and your role. Switch accounts in MetaMask and reconnect to test each role.

## Deployment Details
| Item | Value |
|------|-------|
| Remix VM (Prague) – tested | Deployer / regulator: `0x5B3…eddC4` |
| Public network (MetaMask) | _To be completed_ |
| Contract address | _To be completed_ |
| Deployment tx hash | _To be completed_ |

## Test Cases
Results marked ✅ were observed in Remix VM (screenshots in `screenshots/`). Others are pending. A scripted run of the same cases against an in-memory chain is in `test-results.md` (13/13 passed).

| # | Type | Account | Action | Expected | Observed (Remix VM) |
|---|------|---------|--------|----------|----------|
| 1 | Valid | Regulator | Authorise manufacturer | Success, 1 event | ✅ Success (tx `0x1a4…0a203`) |
| 2 | Valid | Manufacturer | Register batch `B001`, future expiry | Success | Pending |
| 3 | Valid | Anyone | Verify `B001` | Status 1 (genuine) | Pending |
| 4 | Valid | Manufacturer | Recall `B001`, then verify | Status 3 (recalled) | Pending |
| 5 | Invalid | Manufacturer | Register duplicate `B001` | Revert "Batch ID already exists" | Pending |
| 6 | Invalid | Manufacturer | Past expiry | Revert "Expiry must be in the future" | Pending |
| 7 | Invalid | Manufacturer | Empty batch ID or name | Revert "Empty input" | Pending |
| 8 | Invalid | Anyone | Verify unknown ID | Status 0 (not found) | ✅ Status 0, empty name, zero address |
| 9 | Invalid | Regulator | Authorise same address twice | Revert "Already authorised" | Pending |
| 10 | Unauthorised | Non-regulator | Authorise manufacturer | Revert "Only regulator" | Pending |
| 11 | Unauthorised | Non-manufacturer | Register batch | Revert "Not an authorised manufacturer" | ✅ Reverted with that reason (tx `0x279…471ce`) |
| 12 | Unauthorised | Other manufacturer | Recall someone else's batch | Revert "Not allowed to recall" | Pending |

## Screenshots
| Required | File | Status |
|----------|------|--------|
| Contract compilation | `screenshots/01-compile.png` | Pending |
| Contract deployment | `screenshots/02-deploy.png` | Done (Remix VM) |
| MetaMask wallet connection | `screenshots/03-metamask-connect.png` | Pending |
| Successful transaction | `screenshots/04-success-tx.png` | Done (Remix VM) |
| Failed transaction | `screenshots/05-failed-tx.png` | Done (Remix VM) |
| Blockchain data in the UI | `screenshots/06-ui-data.png` | Pending |

## Project Status
**Done**
- Smart contract written, compiled, deployed on Remix VM
- Frontend written (`index.html`, Ethers.js, MetaMask connect)
- Successful transaction, failed (unauthorised) transaction and read call verified in Remix VM
- Scripted test run passes all 13 cases locally

**Remaining**
- Deploy to a network MetaMask can reach (Sepolia or Ganache) and record address
- Set `CONTRACT_ADDRESS` in the frontend and test through the UI
- Complete remaining test rows and screenshots
- Submit Word/PDF with the repository link

> No private keys, seed phrases or passwords are included in this repository.
