## Preparation

### UI coding question: print a navigation menu with categories and children using your framework of choice. You will need a recursive solution. How would you highlight only the "active" item and expand only the path that contains the active item.

- Create a menu with children. Create active/ Expand only the path that contains the active item.
- https://codesandbox.io/s/tivgc?file=/src/index.js

### JS question: implement a JS solution for fetching/reading feature flags from an API. How would you improve performance, caching, share across different apps,...

- How to cache? What is the best cache method?
  - https://www.honeybadger.io/blog/nodejs-caching/
- Async Calls until success. Return fail if fails n times
  - https://stackoverflow.com/questions/46175660/fetch-retry-request-on-failure
- React cacheing
  - https://blog.logrocket.com/options-caching-react/

### Systems design: jira active sprint board, what components would you use, how would you optimize the FE loading of thousands/millions of jira tickets, how would you measure performance.

- Jira active sprint board

  - How to optimize the FE loading millions of tickets?

    - https://blog.logrocket.com/react-hooks-infinite-scroll-advanced-tutorial/
    - https://javascript.plainenglish.io/how-to-handle-large-amounts-of-data-in-a-list-on-the-frontend-80725661ff51
    - How to cache? What is the best cache method?
      - https://www.honeybadger.io/blog/nodejs-caching/
      - Cache Aside
        - 1. Read from Cache
        - 2. Missing? Gets the data from DB (slow)
        - 3. Update Cache
        - Use with write-through cache
      - Read-through Cache
        - 1. Read from Cache
        - 2. on miss handler, read from db and store to cache (fast)
      - Write-through Cache
        - 1. Write to cache
        - 2. Callback to save to db
        - OR
        - 1. Write to db
        - 2. Write to cache
      - Refresh-ahead pattern
        - 1. Always read from cache
        - 2. Async update to cache
    - What do we get the data? REST vs GraphQL?
      - REST
        - Architectural network-based software
        - Returns fixed amount of data
        - Server-driven architecture
        - Caches automatically
        - Sets of URLs exposing single resource
        - Restricted to scaling without updating server-side
      - GraphQL
        - a specification/ query language
        - Returns specified data
        - Client-driven architecture
        - Lacks caching mechanism
        - Single endpoint
        - Scalable without updates in server-side
      - How do we visually render data?
      - Pagination
        - Pros
          - Only displays specified amount of data
          - Easy to go back to the previously visited list
          - Restricts users from calling API multiple times
        - Cons
          - It's hard to navigate on a mobile view
          - The page loses the previously listed items from the screen
          - Lots of components to build (pagination and table)
      - Infinite scrolling
        - Pros
          - Previously visible items are always visible
          - There's only one way for the user to enjoy the view: scroll
          - Everything is happening in the background without distracting the user
          - Most intuitive method as a responsive webapp
        - Cons
          - May cause unwanted API calls
          - Loses the current position when refreshed
      - Manual scrolling
        - Pros
          - Similar to infinite scrolling
          - Only calls API when the user wants
        - Cons
          - Loses the current position when refreshed
      - Lazy component
        - Pros
          - Fetches and renders only when its visible
          - Minimizes the memory usage
        - Cons
          - May look like a glitch

  - How to measure performance?

    - https://www.skovy.dev/blog/measuring-frontend-performance-in-modern-browsers?seed=n6iprx
    - Use _Lighthouse_ or _Other Libraries_
      - First Paints/First Contentful Paint (FP&FCP)
        - first pixels/element on the screen
      - Time to Interactive (TTI)
        - ready to handle user input?
      - First Input Delay (FID)
        - user interacting to browsers responds

Advice to candidates: a lot of emphasis around not just giving a solution but presenting alternatives with pros and cons. Speak your mind.

### Management

### Value
