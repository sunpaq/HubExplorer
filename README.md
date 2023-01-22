# HubExplorer
a tiny tool to search around github

## Tech Stack

- SwiftUI + Combine
- MVVM
- No 3rd party library

## Test
very basic unit tests

- API Test
    - APITest.swift
- UI Test
    - HubExplorerApp.testmode = true
    - ListView+ViewModelMock.swift

## API

https://developer.github.com/v3/search

- Base: https://api.github.com
- Method: GET
- Path: search/repositories
- Query: 'q=' + encode('GitHub Octocat in:readme user:defunkt')
- Limit: 10 request / min

### *TODO List*
to enhancement this tiny app:

- add user login feature
    - so that we can get a better api rate limit.
- add cache result feature.
- add user avator image cache feature.
- enhance api test case
- enhance ui test case
