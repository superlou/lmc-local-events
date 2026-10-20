import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import TagsPanel from './filter-panel';
import EventsTable from './events-table';
import {
  allTimeRange,
  todayRange,
  thisWeekRange,
  thisWeekendRange,
} from '../utils/date-ranges';

const TOP_TAGS = 14;
export const DATE_FILTER = Object.freeze({
  ALL: 'ALL',
  TODAY: 'TODAY',
  THIS_WEEK: 'THIS_WEEK',
  THIS_WEEKEND: 'THIS_WEEKEND',
});

export default class EventExplorer extends Component {
  @tracked selected = [];
  @tracked matchAll = true;
  @tracked showPast = false;
  @tracked showAllTags = false;
  @tracked matchDate = DATE_FILTER.ALL;

  get scope() {
    return this.args.events
      .filter((e) => this.showPast || !e.past)
      .filter(this.filterByDate);
  }

  get matchDateRange() {
    let now = new Date();

    if (this.matchDate === DATE_FILTER.ALL) {
      return allTimeRange();
    } else if (this.matchDate === DATE_FILTER.TODAY) {
      return todayRange(now);
    } else if (this.matchDate === DATE_FILTER.THIS_WEEK) {
      return thisWeekRange(now);
    } else if (this.matchDate === DATE_FILTER.THIS_WEEKEND) {
      return thisWeekendRange(now);
    } else {
      return 0;
    }
  }

  filterByDate = (e) => {
    let d = new Date(Date.parse(e.when));
    let [start, finish] = this.matchDateRange;
    return d >= start && d <= finish;
  };

  get pastCount() {
    return this.args.events.filter((e) => e.past).length;
  }

  get allTags() {
    const counts = new Map();

    for (const e of this.scope) {
      for (const t of e.tags) {
        counts.set(t, (counts.get(t) ?? 0) + 1);
      }
    }

    return [...counts.entries()]
      .map(([name, count]) => ({ name, count }))
      .sort((a, b) => b.count - a.count || a.name.localeCompare(b.name));
  }

  get visibleTags() {
    const base = this.showAllTags
      ? this.allTags
      : this.allTags.slice(0, TOP_TAGS);

    const shown = new Set(base.map((t) => t.name));

    // keep selected tags visible even when they're outside the top list
    const extra = this.selected
      .filter((name) => !shown.has(name))
      .map((name) => ({
        name,
        count: this.allTags.find((t) => t.name === name)?.count ?? 0,
      }));

    return [...extra, ...base].map((t) => ({
      ...t,
      active: this.selected.includes(t.name),
    }));
  }

  get hasMoreTags() {
    return this.allTags.length > TOP_TAGS;
  }

  get moreLabel() {
    return this.showAllTags
      ? 'Show fewer tags'
      : `Show all ${this.allTags.length} tags`;
  }

  get rows() {
    const sel = this.selected;
    return this.scope
      .filter(
        (e) =>
          !sel.length ||
          (this.matchAll
            ? sel.every((t) => e.tags.includes(t))
            : sel.some((t) => e.tags.includes(t))),
      )
      .map((e) => ({
        ...e,
        tagItems: e.tags.map((name) => ({ name, active: sel.includes(name) })),
      }));
  }

  get status() {
    const total = this.scope.length;
    const base = `Showing ${this.rows.length} of ${total} event${total === 1 ? '' : 's'}`;
    return this.selected.length
      ? `${base} tagged ${this.selected.join(this.matchAll ? ' + ' : ' or ')}`
      : base;
  }

  toggle = (tag) => {
    this.selected = this.selected.includes(tag)
      ? this.selected.filter((t) => t !== tag)
      : [...this.selected, tag];
  };

  clear = () => {
    this.selected = [];
  };

  setMatchAll = (value) => {
    this.matchAll = value;
  };

  setMatchDate = (value) => {
    if (this.matchDate === value) {
      this.matchDate = DATE_FILTER.ALL;
    } else {
      this.matchDate = value;
    }
  };

  setShowPast = (event) => {
    this.showPast = event.target.checked;
  };

  toggleAllTags = () => {
    this.showAllTags = !this.showAllTags;
  };

  <template>
    <section class="all wrap" aria-labelledby="all-events">
      <h2 class="sec" id="all-events">All events</h2>
      <p class="sub tight">Sorted by date. Filter to narrow the list.</p>

      <TagsPanel
        @visibleTags={{this.visibleTags}}
        @hasMoreTags={{this.hasMoreTags}}
        @matchAll={{this.matchAll}}
        @moreLabel={{this.moreLabel}}
        @selected={{this.selected}}
        @showPast={{this.showPast}}
        @pastCount={{this.pastCount}}
        @setMatchAll={{this.setMatchAll}}
        @setShowPast={{this.setShowPast}}
        @toggle={{this.toggle}}
        @toggleAllTags={{this.toggleAllTags}}
        @clear={{this.clear}}
        @matchDate={{this.matchDate}}
        @setMatchDate={{this.setMatchDate}}
      />

      <p class="status" aria-live="polite">{{this.status}}</p>

      <div class="tablewrap">
        <EventsTable @events={{this.rows}} @toggle={{this.toggle}} />

        {{#unless this.rows.length}}
          <div class="empty">No events match those tags. Try “Match any” or
            clear a filter.</div>
        {{/unless}}
      </div>
    </section>
  </template>
}
