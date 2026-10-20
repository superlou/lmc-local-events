import TagChip from './tag-chip';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import { DATE_FILTER } from './event-explorer.gjs';

function eq_aria(a, b) {
  return a === b ? 'true' : 'false';
}

<template>
  <div class="panel">
    <div class="panel-head no-margin">
      <strong>Filter by date</strong>
      <div class="ctrls">
        <span class="seg" role="group" aria-label="Tag matching">
          <button
            type="button"
            aria-pressed={{eq_aria @matchDate DATE_FILTER.TODAY}}
            {{on "click" (fn @setMatchDate DATE_FILTER.TODAY)}}
          >Today</button>
          <button
            type="button"
            aria-pressed={{eq_aria @matchDate DATE_FILTER.THIS_WEEK}}
            {{on "click" (fn @setMatchDate DATE_FILTER.THIS_WEEK)}}
          >This Week</button>
          <button
            type="button"
            aria-pressed={{eq_aria @matchDate DATE_FILTER.THIS_WEEKEND}}
            {{on "click" (fn @setMatchDate DATE_FILTER.THIS_WEEKEND)}}
          >This Weekend</button>
        </span>

        <label class="toggle">
          <input
            type="checkbox"
            checked={{@showPast}}
            {{on "change" @setShowPast}}
          />
          Show past events ({{@pastCount}})
        </label>
      </div>
    </div>
    <br />

    <div class="panel-head">
      <strong>Filter by tag</strong>
      <div class="ctrls">
        <span class="seg" role="group" aria-label="Tag matching">
          <button
            type="button"
            aria-pressed={{if @matchAll "true" "false"}}
            {{on "click" (fn @setMatchAll true)}}
          >Match all</button>
          <button
            type="button"
            aria-pressed={{if @matchAll "false" "true"}}
            {{on "click" (fn @setMatchAll false)}}
          >Match any</button>
        </span>

        {{#if @selected.length}}
          <button type="button" class="linkbtn" {{on "click" @clear}}>
            Clear filters
          </button>
        {{/if}}
      </div>
    </div>

    <div class="chips">
      {{#each @visibleTags key="name" as |t|}}
        <TagChip
          @name={{t.name}}
          @count={{t.count}}
          @active={{t.active}}
          @onToggle={{@toggle}}
        />
      {{/each}}

      {{#if @hasMoreTags}}
        <button type="button" class="linkbtn" {{on "click" @toggleAllTags}}>
          {{@moreLabel}}
        </button>
      {{/if}}
    </div>

  </div>
</template>
