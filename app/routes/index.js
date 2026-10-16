import Route from '@ember/routing/route';
import { service } from '@ember/service';

export default class IndexRoute extends Route {
  @service events;
  @service intl;

  model() {
    this.intl.setLocale(['en-us']);
    return this.events;
  }
}
