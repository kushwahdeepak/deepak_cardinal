import React, { useState, useEffect } from 'react'
import isNil from 'lodash.isnil'
import isEmpty from 'lodash.isempty'

function BooleanInput({ label, setInputState, setFilter, testFunc, testAttr, checked, setCheckBox }) {

    useEffect(() => {
        if (!isNil(setFilter)) {
            console.assert(
                !(isNil(testFunc) && isNil(testAttr)),
                'BooleanInput requires either `testFunc` or `testAttr` to be provided'
            )
            testFunc = testFunc ?? getDefaultTestFunc(testAttr)
            setFilter(
                testAttr,
                !checked ? null : (candidate) => testFunc(candidate)
            )
        }

        if (!isNil(setInputState)) {
            setInputState(testAttr, checked)
        }
    }, [checked])

    const handleCheckboxChange = (e) => {
        setCheckBox(testAttr, e.target.checked)
    }

    return (
        <div className="d-flex align-items-center">
            <input
                checked={checked}
                id={testAttr}
                type="checkbox"
                data-test="checkbox-item"
                onChange={handleCheckboxChange}
                style={{ marginRight: '0.5rem' }}
            />
            <label
                data-test="label-item"
                style={{ marginBottom: '0' }}
                htmlFor={testAttr}
            >
                {label}
            </label>
        </div>
    )
}

function getDefaultTestFunc(testAttr) {
    return (candidate) => {
        return !isEmpty(candidate[testAttr])
    }
}

export default BooleanInput
