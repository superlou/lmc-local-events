import { on } from '@ember/modifier';
import { fn } from '@ember/helper';

<template>
  <button
    type="button"
    class="chip"
    aria-pressed={{if @active "true" "false"}}
    {{on "click" (fn @onToggle @name)}}
  >{{@name}}{{#if @count}}<small>{{@count}}</small>{{/if}}</button>
</template>
