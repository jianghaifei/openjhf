export const fromEntries = (pairs: any) => {
  if (Object.fromEntries) {
    return Object.fromEntries(pairs);
  }
  return pairs.reduce(
    (accum: any, [id, value]: [id: any, value: any]) => ({
      ...accum,
      [id]: value,
    }),
    {}
  );
};
