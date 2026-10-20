export function allTimeRange() {
  return [new Date(2000, 1, 1), new Date(2100, 1, 1)];
}

export function todayRange(now) {
  now = new Date(now);
  let start = new Date(new Date(now).setHours(0, 0, 0, 0));
  let finish = new Date(new Date(now).setHours(23, 59, 59, 999));
  return [start, finish];
}

export function thisWeekRange(now) {
  now = new Date(now);
  const currentDay = now.getDay();
  const start = new Date(now);
  start.setDate(now.getDate() - currentDay);
  start.setHours(0, 0, 0, 0);

  const finish = new Date(start);
  finish.setDate(start.getDate() + 7);
  finish.setHours(23, 59, 59, 999);
  return [start, finish];
}

export function thisWeekendRange(now) {
  now = new Date(now);
  const currentDay = now.getDay();

  const baseDate = new Date(now);
  baseDate.setHours(0, 0, 0, 0);

  const dayOffsets = [-2, 4, 3, 2, 1, 0, -1];
  let daysToFriday = dayOffsets[currentDay];

  const start = new Date(now);
  start.setDate(now.getDate() + daysToFriday);
  start.setHours(17, 0, 0, 0);

  const finish = new Date(now);
  finish.setDate(start.getDate() + 2);
  finish.setHours(23, 59, 59, 999);

  return [start, finish];
}
