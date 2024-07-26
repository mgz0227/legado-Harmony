function parseData(data) {
  const lines = data.split('\n');
  const result = [];

  lines.forEach((line) => {
    const parts = line.split('::');
    if (parts.length === 2) {
      const title = parts[0];
      const api = parts[1].replace(/{{String$new Date$$$.replace$'$GMT\+08:00$','$中国标准时间$'$}}/g, new Date().toString());

      result.push({
        title: title,
        api: {
          url: api,
          body: {},
          header: {}
        }
      });
    }
  });

  return result;
}
function parseDataWithMethod(data) {
  const lines = data.split('\n');
  const result = [];

  lines.forEach((line) => {
    const parts = line.split('::');
    if (parts.length === 2) {
      const title = parts[0];
      const apiData = parts[1].split(',');
      if (apiData.length === 2) {
        const url = apiData[0];
        const apiInfo = apiData[1];

        let parsedInfo = apiInfo.replace(/'/g, '"');
        parsedInfo = JSON.parse(parsedInfo);
        const { method, body } = parsedInfo;

        result.push({
          title: title,
          api: {
            url: url.trim(),
            method: method.trim(),
            body: body.trim(),
            header: {}
          }
        });
      }
    }
  });

  return result;
}

export const autoParseData = (data) => {
  if (data.includes('method')) {
    return parseDataWithMethod(data);
  } else {
    return parseData(data);
  }
}

export const AnalysisRules = (data) => {
  return autoParseData(data)
}