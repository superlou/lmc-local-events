import { formatDate, timeLabel } from 'lmc-local-events/utils/dates';
import TagChip from './tag-chip';

<template>
  <table>
    <thead>
      <tr><th>When</th><th>Event</th><th>Where</th><th>Tags</th></tr>
    </thead>
    <tbody>
      {{#each @events key="id" as |e|}}
        <tr class={{if e.past "past"}}>
          <td class="date"><b>{{formatDate e.date}}</b><span>{{timeLabel
                e.date
                e.hasTime
              }}</span></td>
          <td class="ev">
            <a
              class="t"
              href={{e.link}}
              target="_blank"
              rel="noopener noreferrer"
            >{{e.title}}</a>
            <div class="org">{{e.organization}}{{#if e.past}}
                · Past event{{/if}}</div>
            <p class="d">{{e.why}}</p>
          </td>
          <td class="where">{{e.where}}</td>
          <td class="tg">
            <div class="tags">
              {{#each e.tagItems key="name" as |t|}}
                <TagChip
                  @name={{t.name}}
                  @active={{t.active}}
                  @onToggle={{@toggle}}
                />
              {{/each}}
            </div>
          </td>
        </tr>
      {{/each}}
    </tbody>
  </table>
</template>
