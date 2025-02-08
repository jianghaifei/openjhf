export default {
  env: process.env.REACT_APP_ENV,
  app: {
    name: process.env.REACT_APP_NAME,
    url: process.env.REACT_APP_URL,
    res: process.env.REACT_APP_RES_URL,
  },
  api: {
    url: process.env.REACT_APP_API_URL,
    resto: process.env.REACT_APP_API_RESTO
  },
  pageSize: Number(process.env.REACT_APP_PAGE_SIZE)
};
