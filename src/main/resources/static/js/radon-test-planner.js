(function () {
    'use strict';

    var root = document.getElementById('rv-test-planner');
    if (!root) return;

    var form = document.getElementById('rv-planner-form');
    var steps = Array.prototype.slice.call(form.querySelectorAll('.rv-planner-step'));
    var markers = Array.prototype.slice.call(document.querySelectorAll('[data-step-marker]'));
    var nextButton = document.getElementById('rv-next');
    var backButton = document.getElementById('rv-back');
    var resetButton = document.getElementById('rv-reset');
    var editButton = document.getElementById('rv-edit');
    var printButton = document.getElementById('rv-print');
    var errorBox = document.getElementById('rv-form-error');
    var record = document.getElementById('rv-record');
    var storageKey = root.getAttribute('data-storage-key') || 'rv-test-record-v1';
    var currentStep = 0;
    var saveTimer;
    var ruleCatalog = null;

    function analyticsAllowed() {
        return !/^(localhost|127\.0\.0\.1)$/.test(window.location.hostname);
    }

    function field(name) {
        return form.elements.namedItem(name);
    }

    function value(name) {
        var control = field(name);
        if (!control) return '';
        if (control instanceof RadioNodeList) return control.value || '';
        return String(control.value || '').trim();
    }

    function dataFromForm() {
        return {
            stage: value('stage'),
            purpose: value('purpose'),
            device: value('device'),
            level: value('level'),
            room: value('room'),
            zip: value('zip'),
            deviceName: value('deviceName'),
            placementInstructions: value('placementInstructions'),
            startDate: value('startDate'),
            endDate: value('endDate'),
            durationHours: value('durationHours'),
            closedHouse: value('closedHouse'),
            disturbed: value('disturbed'),
            result: value('result'),
            unit: value('unit') || 'pCi/L',
            notes: value('notes')
        };
    }

    function setField(name, savedValue) {
        if (savedValue === undefined || savedValue === null) return;
        var control = field(name);
        if (!control) return;
        if (control instanceof RadioNodeList) {
            Array.prototype.forEach.call(control, function (radio) {
                radio.checked = radio.value === savedValue;
            });
        } else {
            control.value = savedValue;
        }
    }

    function save() {
        try {
            localStorage.setItem(storageKey, JSON.stringify({ step: currentStep, data: dataFromForm() }));
            var status = document.getElementById('rv-save-status');
            status.textContent = 'Saved locally';
        } catch (error) {
            document.getElementById('rv-save-status').textContent = 'Not saved';
        }
    }

    function queueSave() {
        document.getElementById('rv-save-status').textContent = 'Saving…';
        window.clearTimeout(saveTimer);
        saveTimer = window.setTimeout(save, 180);
    }

    function restore() {
        try {
            var saved = JSON.parse(localStorage.getItem(storageKey) || 'null');
            if (!saved || !saved.data) return;
            Object.keys(saved.data).forEach(function (name) { setField(name, saved.data[name]); });
            currentStep = Math.max(0, Math.min(steps.length - 1, Number(saved.step) || 0));
        } catch (error) {
            localStorage.removeItem(storageKey);
        }
    }

    function announceStep() {
        var heading = steps[currentStep].querySelector('h2');
        if (heading) {
            heading.setAttribute('tabindex', '-1');
            heading.focus({ preventScroll: true });
        }
    }

    function showStep(nextStep, shouldFocus) {
        currentStep = Math.max(0, Math.min(steps.length - 1, nextStep));
        steps.forEach(function (step, index) {
            var active = index === currentStep;
            step.classList.toggle('is-active', active);
            step.setAttribute('aria-hidden', active ? 'false' : 'true');
        });
        markers.forEach(function (marker, index) {
            marker.className = index === currentStep ? 'text-pine' : index < currentStep ? 'text-ink' : 'text-stone-400';
        });
        document.getElementById('rv-step-label').textContent = 'Step ' + (currentStep + 1) + ' of ' + steps.length;
        document.getElementById('rv-progress').style.width = (((currentStep + 1) / steps.length) * 100) + '%';
        backButton.classList.toggle('invisible', currentStep === 0);
        nextButton.innerHTML = currentStep === steps.length - 1 ? 'Create my record <span class="ml-3" aria-hidden="true">→</span>' : 'Continue <span class="ml-3" aria-hidden="true">→</span>';
        errorBox.classList.add('hidden');
        queueSave();
        if (shouldFocus) announceStep();
    }

    function validationMessage(step) {
        if (step === 0 && !value('stage')) return 'Choose where you are in the test.';
        if (step === 1 && !value('purpose')) return 'Choose the reason for this test.';
        if (step === 2 && !value('device')) return 'Choose the device type, or choose “I am not sure.”';
        if (step === 3) {
            if (!value('level') || !value('room')) return 'Choose both the level and the room.';
            if (!value('placementInstructions')) return 'Tell us whether the placement followed the device instructions.';
            if (value('zip') && !/^\d{5}$/.test(value('zip'))) return 'Enter a five-digit ZIP code or leave it blank.';
        }
        if (step === 4) {
            if (!value('closedHouse') || !value('disturbed')) return 'Answer both condition questions. “Not sure” is a valid answer.';
            if (value('stage') === 'finished' && !value('durationHours')) return 'Enter the approximate completed test duration.';
            if (value('durationHours') && Number(value('durationHours')) <= 0) return 'Enter a duration greater than zero.';
            if (value('startDate') && value('endDate') && value('endDate') < value('startDate')) return 'The end date cannot be before the start date.';
        }
        if (step === 5 && value('result')) {
            var result = Number(value('result'));
            if (!Number.isFinite(result) || result < 0 || result > 999) return 'Enter a reported result from 0 to 999, or leave it blank.';
        }
        return '';
    }

    function calculateDurationFromDates() {
        var start = value('startDate');
        var end = value('endDate');
        var duration = field('durationHours');
        if (!start || !end || !duration) return;
        var milliseconds = new Date(end).getTime() - new Date(start).getTime();
        if (!Number.isFinite(milliseconds) || milliseconds < 0) return;
        duration.value = String(Math.round((milliseconds / 3600000) * 10) / 10);
        duration.dataset.autoCalculated = 'true';
        var note = document.getElementById('rv-duration-note');
        if (note) note.textContent = 'Calculated from the recorded start and end times. You can correct it.';
        queueSave();
    }

    function conditionMatches(data, condition) {
        var actual = data[condition.field];
        if (condition.operator === 'eq') return actual === condition.value;
        if (condition.operator === 'in') return condition.value.indexOf(actual) >= 0;
        if (condition.operator === 'present') return actual !== undefined && actual !== null && String(actual).trim() !== '';
        if (condition.operator === 'numberLt' || condition.operator === 'numberLte') {
            if (actual === undefined || actual === null || String(actual).trim() === '') return false;
            var number = Number(actual);
            if (!Number.isFinite(number)) return false;
            return condition.operator === 'numberLt' ? number < Number(condition.value) : number <= Number(condition.value);
        }
        return false;
    }

    function catalogItemMatches(data, item) {
        return item.conditions.every(function (condition) { return conditionMatches(data, condition); });
    }

    function showError(message) {
        errorBox.textContent = message;
        errorBox.classList.remove('hidden');
        errorBox.focus();
    }

    function labelFor(group, key) {
        var labels = {
            stage: { planning: 'Preparing a test', running: 'Test in progress', finished: 'Completed test' },
            purpose: { first: 'First or routine home test', transaction: 'Buying or selling a home', confirm: 'Confirming an earlier result', 'post-mitigation': 'Checking after mitigation' },
            device: { short: 'Short-term passive kit', long: 'Long-term passive kit', continuous: 'Continuous electronic monitor', unknown: 'Device type not confirmed' },
            level: { basement: 'Basement', first: 'First floor', upper: 'Upper floor', 'unit-lowest': 'Lowest level inside the unit' },
            room: { living: 'Living room / family room', bedroom: 'Bedroom', office: 'Office / den', 'open-basement': 'Open basement area', 'kitchen-bath': 'Kitchen or bathroom', storage: 'Closet or storage area', other: 'Other' },
            answer: { yes: 'Yes', no: 'No', unsure: 'Not sure / not applicable' }
        };
        return (labels[group] && labels[group][key]) || key || 'Not recorded';
    }

    function assess(data) {
        var findings = ruleCatalog.rules.filter(function (rule) { return catalogItemMatches(data, rule); });
        var contextActions = ruleCatalog.contextActions.filter(function (item) { return catalogItemMatches(data, item); });
        var hasRetest = findings.some(function (finding) { return finding.severity === 'retest'; });
        var hasCaution = findings.some(function (finding) { return finding.severity === 'caution'; });
        var actions = findings.map(function (finding) { return { message: finding.action, sourceIds: finding.sourceIds }; });
        actions = actions.concat(contextActions);

        if (data.stage === 'planning') {
            actions.push({ message: 'Record the exact start time when the device is opened or activated.', sourceIds: ['CDC_HOME_TESTING_2024'] });
        } else if (!findings.length) {
            actions.push({ message: 'Keep this record with the laboratory report or monitor export.', sourceIds: [] });
        }
        if (!data.result) actions.push({ message: 'Add the result and laboratory report when they become available.', sourceIds: [] });

        if (hasRetest) return { tone: 'retest', title: 'Retest may be needed', summary: 'A recorded detail conflicts with a source-backed duration definition. Confirm the device instructions before deciding.', findings: findings, actions: actions };
        if (hasCaution) return { tone: 'caution', title: data.stage === 'planning' ? 'Setup needs one more check' : 'The procedure may be compromised', summary: 'One or more details need to be checked before relying on the setup or result.', findings: findings, actions: actions };
        return { tone: data.stage === 'planning' ? 'planning' : 'consistent', title: data.stage === 'planning' ? 'Setup plan is ready' : 'The procedure is internally consistent', summary: 'No conflict was found against the published checks in rule set ' + ruleCatalog.catalogVersion + '. This is not certification; device and state instructions still control.', findings: [], actions: actions };
    }

    function appendSourceLinks(container, sourceIds) {
        if (!sourceIds || !sourceIds.length) return;
        var sourceLine = document.createElement('span');
        sourceLine.className = 'mt-1 block text-xs font-bold text-stone-500';
        sourceLine.append(document.createTextNode('Evidence: '));
        sourceIds.forEach(function (sourceId, index) {
            var source = ruleCatalog.sources[sourceId];
            if (!source) return;
            if (index > 0) sourceLine.append(document.createTextNode(' · '));
            var link = document.createElement('a');
            link.href = source.url;
            link.target = '_blank';
            link.rel = 'noopener';
            link.className = 'text-pine underline';
            link.textContent = source.publisher;
            sourceLine.append(link);
        });
        container.appendChild(sourceLine);
    }

    function addRecordRow(container, term, description) {
        var row = document.createElement('div');
        row.className = 'rv-record-row';
        var dt = document.createElement('dt');
        dt.className = 'text-xs font-black uppercase tracking-wider text-stone-500';
        dt.textContent = term;
        var dd = document.createElement('dd');
        dd.className = 'font-bold text-ink';
        dd.textContent = description || 'Not recorded';
        row.appendChild(dt);
        row.appendChild(dd);
        container.appendChild(row);
    }

    function renderRecord() {
        var data = dataFromForm();
        var assessment = assess(data);
        var assessmentBox = document.getElementById('rv-assessment');
        var toneClasses = {
            planning: 'border-pine bg-[#eef2e8]',
            consistent: 'border-pine bg-[#eef2e8]',
            caution: 'border-[#A85D18] bg-[#fff6e8]',
            retest: 'border-[#A43D32] bg-[#fff0ee]'
        };
        assessmentBox.className = 'mt-7 border-l-8 p-5 ' + toneClasses[assessment.tone];
        assessmentBox.replaceChildren();
        var title = document.createElement('h3');
        title.className = 'font-display text-3xl font-bold text-ink';
        title.textContent = assessment.title;
        var summary = document.createElement('p');
        summary.className = 'mt-2 font-semibold leading-relaxed text-stone-700';
        summary.textContent = assessment.summary;
        var findings = document.createElement('ul');
        findings.className = 'mt-4 space-y-2 text-sm font-semibold text-stone-700';
        if (!assessment.findings.length) {
            var clearItem = document.createElement('li');
            clearItem.textContent = '— No procedural conflict was found in the answers entered.';
            findings.appendChild(clearItem);
        }
        assessment.findings.forEach(function (finding) {
            var item = document.createElement('li');
            item.append(document.createTextNode('— ' + finding.message));
            appendSourceLinks(item, finding.sourceIds);
            findings.appendChild(item);
        });
        assessmentBox.append(title, summary, findings);

        document.getElementById('rv-record-date').textContent = 'Created ' + new Intl.DateTimeFormat('en-US', { dateStyle: 'long' }).format(new Date());
        var details = document.getElementById('rv-record-details');
        details.replaceChildren();
        addRecordRow(details, 'Stage', labelFor('stage', data.stage));
        addRecordRow(details, 'Reason', labelFor('purpose', data.purpose));
        addRecordRow(details, 'Device', data.deviceName ? labelFor('device', data.device) + ' — ' + data.deviceName : labelFor('device', data.device));
        addRecordRow(details, 'Placement', labelFor('room', data.room) + ', ' + labelFor('level', data.level));
        addRecordRow(details, 'Device instructions', labelFor('answer', data.placementInstructions));
        addRecordRow(details, 'Location', data.zip ? 'ZIP ' + data.zip : 'ZIP not recorded');
        addRecordRow(details, 'Test dates', data.startDate || data.endDate ? (data.startDate || 'Not recorded') + ' to ' + (data.endDate || 'In progress / not recorded') : 'Not recorded');
        addRecordRow(details, 'Duration', data.durationHours ? data.durationHours + ' hours' : 'Not recorded');
        addRecordRow(details, 'Closed-house conditions', labelFor('answer', data.closedHouse));
        addRecordRow(details, 'Device disturbed', labelFor('answer', data.disturbed));
        addRecordRow(details, 'Reported result', data.result ? data.result + ' ' + data.unit : 'Not recorded');
        if (data.notes) addRecordRow(details, 'Notes', data.notes);

        var actions = document.getElementById('rv-next-actions');
        actions.replaceChildren();
        assessment.actions.forEach(function (action) {
            var item = document.createElement('li');
            item.className = 'grid grid-cols-[24px_1fr] gap-3';
            var mark = document.createElement('span');
            mark.className = 'font-black text-pine';
            mark.textContent = '→';
            var copy = document.createElement('span');
            copy.textContent = action.message;
            appendSourceLinks(copy, action.sourceIds);
            item.append(mark, copy);
            actions.appendChild(item);
        });

        root.classList.add('hidden');
        record.classList.remove('hidden');
        record.scrollIntoView({ behavior: window.matchMedia('(prefers-reduced-motion: reduce)').matches ? 'auto' : 'smooth', block: 'start' });
        save();
        if (analyticsAllowed() && typeof window.gtag === 'function') window.gtag('event', 'test_record_completed', { test_stage: data.stage, test_device: data.device, procedure_status: assessment.tone });
    }

    nextButton.addEventListener('click', function () {
        var message = validationMessage(currentStep);
        if (message) { showError(message); return; }
        if (currentStep === steps.length - 1) renderRecord();
        else showStep(currentStep + 1, true);
    });
    backButton.addEventListener('click', function () { showStep(currentStep - 1, true); });
    form.addEventListener('input', queueSave);
    form.addEventListener('change', queueSave);
    field('startDate').addEventListener('change', calculateDurationFromDates);
    field('endDate').addEventListener('change', calculateDurationFromDates);
    field('durationHours').addEventListener('input', function () {
        delete field('durationHours').dataset.autoCalculated;
        var note = document.getElementById('rv-duration-note');
        if (note) note.textContent = 'Use the exact exposure time shown by the kit or monitor when available.';
    });
    resetButton.addEventListener('click', function () {
        if (!window.confirm('Clear every answer in this test record?')) return;
        localStorage.removeItem(storageKey);
        form.reset();
        showStep(0, true);
    });
    editButton.addEventListener('click', function () {
        record.classList.add('hidden');
        root.classList.remove('hidden');
        showStep(5, true);
        root.scrollIntoView({ behavior: 'auto', block: 'start' });
    });
    printButton.addEventListener('click', function () { window.print(); });

    nextButton.disabled = true;
    nextButton.textContent = 'Loading official checks…';
    fetch('/data/radon-test-protocol-rules.json', { headers: { 'Accept': 'application/json' } })
        .then(function (response) {
            if (!response.ok) throw new Error('Rule catalog could not be loaded.');
            return response.json();
        })
        .then(function (catalog) {
            if (!catalog.catalogVersion || !catalog.sources || !Array.isArray(catalog.rules)) throw new Error('Rule catalog is incomplete.');
            ruleCatalog = catalog;
            root.setAttribute('data-rule-version', catalog.catalogVersion);
            var version = document.getElementById('rv-rule-version');
            if (version) version.textContent = 'Official-source rule set ' + catalog.catalogVersion + ' · reviewed ' + catalog.reviewedOn;
            nextButton.disabled = false;
            restore();
            showStep(currentStep, false);
            if (analyticsAllowed() && typeof window.gtag === 'function') window.gtag('event', 'test_planner_view', { rule_version: catalog.catalogVersion });
        })
        .catch(function () {
            showError('The official-source checks could not be loaded. Refresh the page before creating a record.');
            nextButton.textContent = 'Checks unavailable';
        });
})();
