import Component from '@glimmer/component';
import { service } from '@ember/service';
import { htmlSafe } from '@ember/template';
import { whenLabel } from 'lmc-local-events/utils/dates';

const background = (img) => htmlSafe(`background-image:url(data:image/jpeg;base64,${img})`);

export default class FeaturedEvents extends Component {
  @service events;

  <template>
    <div class="wrap">
      <div class="featured" aria-label="Featured events">
        {{#each this.events.featured key="event.id" as |f|}}
          <a
            class="feat"
            href={{f.event.link}}
            target="_blank"
            rel="noopener noreferrer"
            style={{background f.img}}
            aria-label={{f.event.title}}
          >
            <div class="body">
              <span class="badge">Featured</span>
              <h2>{{f.event.title}}</h2>
              <p class="meta">{{whenLabel f.event.date f.event.hasTime}} &nbsp;·&nbsp; {{f.event.where}}</p>
              <p class="why">{{f.event.why}}</p>
              <span class="go">Event details →</span>
            </div>
          </a>
        {{/each}}
      </div>
    </div>
  </template>
}
