import Service from '@ember/service';
import rawEvents from '../data/events.json';
import featuredImages from '../data/featured.json';
import { parseWhen, startOfToday } from 'lmc-local-events/utils/dates';

const today = startOfToday();

const all = rawEvents
  .map((e) => ({ ...e, ...parseWhen(e.when) }))
  .map((e) => ({ ...e, past: e.date < today }))
  .sort((a, b) => a.date - b.date || a.id - b.id);

export default class EventsService extends Service {
  all = all;

  featured = featuredImages
    .map(({ id, img }) => ({ event: all.find((e) => e.id === id), img }))
    .filter((f) => f.event);
}
