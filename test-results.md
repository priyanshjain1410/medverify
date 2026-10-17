# Local test results (solc 0.8.24, in-memory Ganache)

| # | Type | Action | Expected | Observed | Result |
|---|---|---|---|---|---|
| 1 | Valid | Regulator authorises manufacturer | Success | Success (tx 0xafa7bc9f95…) | PASS |
| 2 | Valid | Manufacturer registers B001 | Success | Success (tx 0x1b8b4c093b…) | PASS |
| 3 | Valid | Verify B001 | status 1 | status 1 | PASS |
| 5 | Invalid | Duplicate B001 | Batch ID already exists | Revert: Batch ID already exists | PASS |
| 6 | Invalid | Past expiry | Expiry must be in the future | Revert: Expiry must be in the future | PASS |
| 7 | Invalid | Empty batch ID | Empty input | Revert: Empty input | PASS |
| 8 | Invalid | Verify unknown ID | status 0 | status 0 | PASS |
| 9 | Invalid | Authorise same address twice | Already authorised | Revert: Already authorised | PASS |
| 10 | Unauthorised | Non-regulator authorises | Only regulator | Revert: Only regulator | PASS |
| 11 | Unauthorised | Non-manufacturer registers | Not an authorised manufacturer | Revert: Not an authorised manufacturer | PASS |
| 12 | Unauthorised | Other manufacturer recalls B001 | Not allowed to recall | Revert: Not allowed to recall | PASS |
| 4 | Valid | Manufacturer recalls B001 | Success | Success (tx 0x95802a32f4…) | PASS |
| 4b | Valid | Verify B001 after recall | status 3 | status 3 | PASS |
