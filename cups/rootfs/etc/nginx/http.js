function api(r) {
    r.subrequest('/info')
        .then(res => {
            if (res.status === 401) {
                throw new Error('Permission denied');
            } else if (res.status === 404) {
                throw new Error('Addon info not found');
            } else if (res.status === 405) {
                throw new Error('Incorrect HTTP method used');
            } else if (res.status !== 200) {
                throw new Error('HTTP ' + res.status);
            }
            const parsed = JSON.parse(res.responseBody);
            if (parsed.result === 'error') {
                throw new Error('Response: ' + parsed.message);
            }
            r.headersOut['Ingress-Entry'] = parsed.data.ingress_entry;
            r.return(200);
        })
        .catch(e => r.return(500, 'Addon info API error: ' + e));
}