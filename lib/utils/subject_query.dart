const subjectQuery = """
Array.from(document.querySelectorAll('table')[50].querySelectorAll('tr.rich-table-row')).map(function(el) {
    var tdList = el.querySelectorAll('td');
    return {
        code: tdList[1].innerText,
        name: tdList[3].innerText,
        classGroup: tdList[2].innerText,
        weeklyClassCount: parseInt(tdList[5].innerText),
        times: tdList[7].innerText.split('\\n').filter(t => t != '').map((time) => {
            var [weekDay, startTime, count, center, room] = time.split(/\\.|-| \\/ / );
            return {
                weekDay,
                startTime,
                count: parseInt(count),
                center,
                room,
            }
        })
    }
})
""";

const subjectUrl =
    "https://cagr.sistemas.ufsc.br/modules/aluno/espelhoMatricula/";
