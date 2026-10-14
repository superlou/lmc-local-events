import TagChip from './tag-chip';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';

<template>
  <div class="panel">
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
        <label class="toggle">
          <input
            type="checkbox"
            checked={{@showPast}}
            {{on "change" @setShowPast}}
          />
          Show past events ({{@pastCount}})
        </label>
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
    </div>

    {{#if @hasMoreTags}}
      <button type="button" class="linkbtn" {{on "click" @toggleAllTags}}>
        {{@moreLabel}}
      </button>
    {{/if}}
  </div>
</template>
