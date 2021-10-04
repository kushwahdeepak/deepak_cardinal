import React, { useState, useEffect } from 'react'
import isNil from 'lodash.isnil'
import Util from '../../../../utils/util'
import { Col, Row, Container } from 'react-bootstrap'

function MultiBooleanInput({
    checkboxInfo,
    setInputState,
    setFilter,
    testFunc,
    testAttr,
    initialValues = [],
}) {
    const [checkedOptions, setCheckedOptions] = useState([...initialValues])

    useEffect(() => {
        if (!isNil(setFilter)) {
            console.assert(
                !(isNil(testFunc) && isNil(testAttr)),
                'MultiBooleanInput requires either `testFunc` or `testAttr` to be provided'
            )
            testFunc = testFunc ?? getDefaultTestFunc(testAttr)
            setFilter(
                testAttr,
                checkedOptions.length === 0
                    ? null
                    : (candidate) => testFunc(candidate, checkedOptions)
            )
        }

        if (!isNil(setInputState)) {
            setInputState(testAttr, checkedOptions)
        }
    }, [checkedOptions])

    const handleCheckboxChange = (e) => {
        const checked = e.target.checked
        const option = e.target.id

        const newCheckedBoxes = checked
            ? checkedOptions.concat(option)
            : checkedOptions.filter((cbOption) => cbOption !== option)

        setCheckedOptions(newCheckedBoxes)
    }

    useEffect(() => {
        setCheckedOptions(initialValues)
    }, [initialValues.length])

    return (
        <>
            {checkboxInfo &&
                checkboxInfo.map((cb) => (
                    <div className="label-and-checkbox" key={cb.option}>
                        <input
                            id={cb.option}
                            type="checkbox"
                            onChange={handleCheckboxChange}
                            checked={checkedOptions.includes(cb.option)}
                            style={{ marginRight: '0.5rem' }}
                        />
                        {cb.label}
                    </div>
                ))}
        </>
    )
}

function getDefaultTestFunc(testAttr) {
    return (candidate, checkedOptions) => {
        return Util.attributePassesStringSetFilter(
            candidate,
            testAttr,
            checkedOptions
        )
    }
}

export default MultiBooleanInput
