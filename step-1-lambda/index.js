exports.handler = async (event, context) => {
  console.log(event);
  console.log(context);
  console.log("Step 1 fired!");
  const next = {
    ...event,
    s3_geo_parquet: {
      bucket: "s3_bucket",
      key: "s3_key"
    },
  };

  context.succeed(next);
};
