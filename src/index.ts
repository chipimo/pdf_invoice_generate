import app from './app';

const port = process.env.PORT || 8080;
app.listen(port, () => {
  /* eslint-disable no-console */
  console.log(`Server is listening on port ${port}`);
  /* eslint-enable no-console */
});
