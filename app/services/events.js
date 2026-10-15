import Service from '@ember/service';
import { parseWhen, startOfToday } from 'lmc-local-events/utils/dates';
import { tracked } from '@glimmer/tracking';

const today = startOfToday();

export default class EventsService extends Service {
  @tracked all = [];
  @tracked featured = [];

  constructor() {
    super(...arguments);
    this.loadEvents();
  }

  async loadEvents() {
    const response = (this.rawEvents = await fetch(
      'https://lmc-local-events-data.s3.us-east-1.amazonaws.com/public/data.json',
    ));

    const rawEvents = await response.json();

    this.all = rawEvents.events
      .map((e) => ({ ...e, ...parseWhen(e.when) }))
      .map((e) => ({ ...e, past: e.date < today }))
      .sort((a, b) => a.date - b.date || a.id - b.id);

    this.featured = rawEvents.featured
      .map(({ id, background_b64 }) => ({
        event: this.all.find((e) => e.id === id),
        background_b64,
      }))
      .filter((f) => f.event);
  }
}
