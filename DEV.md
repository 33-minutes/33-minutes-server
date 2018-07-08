## GraphQL API

Use GraphQL IDE.

### Create a User

```graphql
mutation {
  createUser(
    input: {
      name: "dB.",
      email: "user@example.org",
      password: "password"
    }
  ) {
    user {
      id
      email
    }
  }
}
```

### Login

```graphql
mutation {
  login(
    input: {
      email: "dblock@dblock.org",
      password: "password"
    }
  ) {
    user {
      id
      email
    }
  }
}
```

This sets session cookies.

### Current User

```graphql
query {
  user {
    id
  }
}
```

### Create a Meeting

```graphql
mutation {
  createMeeting(
    input: {
      title: "Meeting 1",
      started: "2018-07-07 12:00 PM EST",
      finished: "2018-07-07 1:00 PM EST"
    }
  ) {
    meeting {
      id
      title
      started
      finished
    }
  }
}
```

### Get User with Meetings

```graphql
query {
  user {
    name
    meetings {
      id
      title
    }
  }
}
```
