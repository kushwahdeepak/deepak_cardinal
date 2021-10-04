import React, { useState, useEffect } from 'react'
import Container from 'react-bootstrap/Container'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import isNil from 'lodash.isnil'

const RadioInput = ({
    radioInfo,
    setInputState,
    setFilter,
    testFunc,
    testAttr,
    initialValue,
}) => {
    const [checkedOption, setCheckedOption] = useState('')

    useEffect(() => {
        if (!isNil(setFilter)) {
            console.assert(
                !(isNil(testFunc) && isNil(testAttr)),
                'RadioInput requires either `testFunc` or `testAttr` to be provided'
            )
            testFunc = testFunc ?? getDefaultTestFunc(testAttr)
            setFilter(
                testAttr,
                !checkedOption ? null : (candidate) => testFunc(candidate)
            )
        }

        if (!isNil(setInputState)) {
            setInputState(testAttr, checkedOption)
        }
    }, [checkedOption])

    const handleRadioChange = (e) => {
        setCheckedOption(e.target.value)
    }

    return (
        <div className="p-2">
                        {radioInfo &&
                            radioInfo.map((cb, i) => (
                                <div key={i}>
                                    <input
                                        type="radio"
                                        value={cb}
                                        onChange={handleRadioChange}
                                        checked={initialValue === cb}
                                        style={{ marginRight: '0.5rem' }}
                                    />
                                    {cb}
                                </div>
                            ))}
        </div>
    )
}

function getDefaultTestFunc(testAttr) {
    return (candidate) => {
        return !isEmpty(candidate[testAttr])
    }
}

export default RadioInput
