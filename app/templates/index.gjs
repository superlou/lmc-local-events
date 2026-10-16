import { pageTitle } from 'ember-page-title';
import FeaturedEvents from 'lmc-local-events/components/featured-events';
import EventExplorer from 'lmc-local-events/components/event-explorer';
import { formatDate, formatTime } from 'ember-intl';

<template>
  {{pageTitle "LMC Media Community Events"}}

  <header class="top wrap">
    <p class="eyebrow">Mamaroneck &amp; Larchmont</p>
    <h1>Community Events</h1>
    <p class="sub">Three picks from
      <a href="https://lmcmedia.org">LMC Media</a>, then everything else
      happening nearby.</p>
  </header>

  <main>
    <FeaturedEvents @events={{@model.featured}} />
    <EventExplorer @events={{@model.all}} />
  </main>

  <footer>
    <div class="wrap">
      Brought to you by
      <strong><a href="http://lmcmedia.org">LMC Media</a></strong>. Event
      details come from local organizations; check each event's page for the
      latest information.
    </div>
    <div class="wrap light">
      Last updated at
      {{formatDate @model.built_at}}
      {{formatTime @model.built_at}}.
    </div>
  </footer>
</template>
