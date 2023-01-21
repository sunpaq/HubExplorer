# HubExplorer
a tiny tool to search around github

## API

- Base: https://developer.github.com/v3
- Method: GET
- Path: search/repositories
- Query: 'q=' + encode('GitHub Octocat in:readme user:defunkt')
- Limit: 10 request / min
