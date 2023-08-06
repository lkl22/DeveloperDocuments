export function nowTime(): string {
  let date = new Date();
  return `${date.getFullYear()}${formatNum(date.getMonth() + 1)}${formatNum(date.getDate())} ${formatNum(
    date.getHours())}:${formatNum(date.getMinutes())}`;
}

function formatNum(data: number): string {
  return `${data}`.padStart(2, '0');
}