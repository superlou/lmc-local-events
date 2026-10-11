// "10/25/26 6:30 PM" or "10/18/26" (no time) -> { date, hasTime }
export function parseWhen(when) {
  const m = when.match(/^(\d+)\/(\d+)\/(\d+)(?:\s+(\d+):(\d+)\s*([AP]M))?/i);
  let hour = null;
  let minute = 0;
  if (m[4]) {
    hour = (Number(m[4]) % 12) + (m[6].toUpperCase() === 'PM' ? 12 : 0);
    minute = Number(m[5]);
  }
  const date = new Date(2000 + Number(m[3]), Number(m[1]) - 1, Number(m[2]), hour ?? 0, minute);
  return { date, hasTime: hour !== null };
}

export function startOfToday() {
  const d = new Date();
  d.setHours(0, 0, 0, 0);
  return d;
}

export const formatDate = (d) =>
  d.toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' });

const formatTime = (d) => d.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' });

export const timeLabel = (d, hasTime) => (hasTime ? formatTime(d) : 'Time not listed');

export const whenLabel = (d, hasTime) =>
  hasTime ? `${formatDate(d)} · ${formatTime(d)}` : formatDate(d);
