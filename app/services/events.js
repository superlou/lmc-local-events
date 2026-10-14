import Service from '@ember/service';
import rawEvents from '../data/events.json';
import featuredImages from '../data/featured.json';
import { parseWhen, startOfToday } from 'lmc-local-events/utils/dates';

const today = startOfToday();

export default class EventsService extends Service {
  all = rawEvents
    .map((e) => ({ ...e, ...parseWhen(e.when) }))
    .map((e) => ({ ...e, past: e.date < today }))
    .sort((a, b) => a.date - b.date || a.id - b.id);

  featured = featuredImages
    .map(({ id, img }) => ({ event: this.all.find((e) => e.id === id), img }))
    .filter((f) => f.event);
}
