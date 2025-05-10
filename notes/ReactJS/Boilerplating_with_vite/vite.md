# Boilerplating with Vite & Vitest & React Testing Library

1. Start vite with react project

```bash
npm create vite@latest
```

2. Install Vitest

```bash
npm i -D vitest
```

Then add scripts

```json
{
  "scripts": {
    "test": "vitest"
  }
}
```

3. Install jsdom

```bash
npm i -D jsdom
```

4. Configure `vite.config.ts` by adding reference at the top, and adding test environment as `jsdom`

```js
/// <reference types="vitest/config" />
//imports...
export default defineConfig({
  plugins: [react()],
  test: {
    environment: "jsdom", // add this line
  },
});
```

5. Install React Testing Library (RTL), then add test `test_setup.ts` in the root

```bash
npm i -D @testing-library/dom @testing-library/jest-dom @testing-library/react @testing-library/user-event @types/react @types/react-dom
```

```typescript
//test_setup.ts
import "@testing-library/jest-dom/vitest";
import { afterEach } from "vitest";
import { cleanup } from "@testing-library/react";

// runs a clean after each test case (e.g. clearing jsdom)
afterEach(() => {
  cleanup();
});
```

6. Configure `vite.config.ts`

```typescript
/// <reference types="vitest/config" />
//imports...
export default defineConfig({
    plugins: [react()],
    test: {
      globals: true,
      environment: 'jsdom',
      setupFiles: "./test_setup.ts"
    },
 },
})
```

7. Create test.tsx and start testing!

```tsx
import { describe, it, expect } from "vitest";
//...
```
