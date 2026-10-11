import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { service } from '@ember/service';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import TagChip from './tag-chip';
import { formatDate, timeLabel } from 'lmc-local-events/utils/dates';

const TOP_TAGS = 14;

export default class EventExplorer extends Component {
  @service events;

  @tracked selected = [];
  @tracked matchAll = true;
  @tracked showPast = false;
  @tracked showAllTags = false;

  get scope() {
    return this.events.all.filter((e) => this.showPast || !e.past);
  }

  get pastCount() {
    return this.events.all.filter((e) => e.past).length;
  }

  get allTags() {
    const counts = new Map();
    for (const e of this.scope) for (const t of e.tags) counts.set(t, (counts.get(t) ?? 0) + 1);
    return [...counts.entries()]
      .map(([name, count]) => ({ name, count }))
      .sort((a, b) => b.count - a.count || a.name.localeCompare(b.name));
  }

  get visibleTags() {
    const base = this.showAllTags ? this.allTags : this.allTags.slice(0, TOP_TAGS);
    const shown = new Set(base.map((t) => t.name));
    // keep selected tags visible even when they're outside the top list
    const extra = this.selected
      .filter((name) => !shown.has(name))
      .map((name) => ({ name, count: this.allTags.find((t) => t.name === name)?.count ?? 0 }));
    return [...extra, ...base].map((t) => ({ ...t, active: this.selected.includes(t.name) }));
  }

  get hasMoreTags() {
    return this.allTags.length > TOP_TAGS;
  }

  get moreLabel() {
    return this.showAllTags ? 'Show fewer tags' : `Show all ${this.allTags.length} tags`;
  }

  get rows() {
    const sel = this.selected;
    return this.scope
      .filter(
        (e) =>
          !sel.length ||
          (this.matchAll ? sel.every((t) => e.tags.includes(t)) : sel.some((t) => e.tags.includes(t))),
      )
      .map((e) => ({ ...e, tagItems: e.tags.map((name) => ({ name, active: sel.includes(name) })) }));
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

  setShowPast = (event) => {
    this.showPast = event.target.checked;
  };

  toggleAllTags = () => {
    this.showAllTags = !this.showAllTags;
  };

  <template>
    <section class="all wrap" aria-labelledby="all-events">
      <h2 class="sec" id="all-events">All events</h2>
      <p class="sub tight">Sorted by date. Pick tags to narrow the list.</p>

      <div class="panel">
        <div class="panel-head">
          <strong>Filter by tag</strong>
          <div class="ctrls">
            <span class="seg" role="group" aria-label="Tag matching">
              <button type="button" aria-pressed={{if this.matchAll "true" "false"}} {{on "click" (fn this.setMatchAll true)}}>Match all</button>
              <button type="button" aria-pressed={{if this.matchAll "false" "true"}} {{on "click" (fn this.setMatchAll false)}}>Match any</button>
            </span>
            <label class="toggle">
              <input type="checkbox" checked={{this.showPast}} {{on "change" this.setShowPast}} />
              Show past events ({{this.pastCount}})
            </label>
            {{#if this.selected.length}}
              <button type="button" class="linkbtn" {{on "click" this.clear}}>Clear filters</button>
            {{/if}}
          </div>
        </div>
        <div class="chips">
          {{#each this.visibleTags key="name" as |t|}}
            <TagChip @name={{t.name}} @count={{t.count}} @active={{t.active}} @onToggle={{this.toggle}} />
          {{/each}}
        </div>
        {{#if this.hasMoreTags}}
          <button type="button" class="linkbtn" {{on "click" this.toggleAllTags}}>{{this.moreLabel}}</button>
        {{/if}}
      </div>

      <p class="status" aria-live="polite">{{this.status}}</p>
      <div class="tablewrap">
        <table>
          <thead>
            <tr><th>When</th><th>Event</th><th>Where</th><th>Tags</th></tr>
          </thead>
          <tbody>
            {{#each this.rows key="id" as |e|}}
              <tr class={{if e.past "past"}}>
                <td class="date"><b>{{formatDate e.date}}</b><span>{{timeLabel e.date e.hasTime}}</span></td>
                <td class="ev">
                  <a class="t" href={{e.link}} target="_blank" rel="noopener noreferrer">{{e.title}}</a>
                  <div class="org">{{e.organization}}{{#if e.past}} · Past event{{/if}}</div>
                  <p class="d">{{e.why}}</p>
                </td>
                <td class="where">{{e.where}}</td>
                <td class="tg">
                  <div class="tags">
                    {{#each e.tagItems key="name" as |t|}}
                      <TagChip @name={{t.name}} @active={{t.active}} @onToggle={{this.toggle}} />
                    {{/each}}
                  </div>
                </td>
              </tr>
            {{/each}}
          </tbody>
        </table>
        {{#unless this.rows.length}}
          <div class="empty">No events match those tags. Try “Match any” or clear a filter.</div>
        {{/unless}}
      </div>
    </section>
  </template>
}
