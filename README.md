# lmc-local-events (Ember 7.3)

Single-page Ember 7.3 app (Vite + Embroider, `.gjs` components).

    npm install
    npm start        # dev server
    npm run build    # production build in dist/

- `app/data/events.json` – event list; `app/data/featured.json` – base64 images for the three featured event ids
- `app/services/events.js` – parses/sorts events (by date) and resolves the featured events
- `app/components/featured-events.gjs`, `event-explorer.gjs` (tag filtering + table), `tag-chip.gjs`
