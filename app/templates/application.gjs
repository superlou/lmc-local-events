import { pageTitle } from 'ember-page-title';
import FeaturedEvents from 'lmc-local-events/components/featured-events';
import EventExplorer from 'lmc-local-events/components/event-explorer';

<template>
  {{pageTitle "Mamaroneck Community Events"}}

  <header class="top wrap">
    <p class="eyebrow">Mamaroneck &amp; Larchmont</p>
    <h1>Community Events</h1>
    <p class="sub">Three picks worth planning around, then everything else happening nearby.</p>
  </header>

  <main>
    <FeaturedEvents />
    <EventExplorer />
  </main>

  <footer>
    <div class="wrap">Event details come from local organizations; check each event's page for the latest information.</div>
  </footer>
</template>
