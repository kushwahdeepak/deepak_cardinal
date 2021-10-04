import React, { useEffect, useState, useRef } from 'react'
import TagList from '../../TagList/TagList'
import Button from 'react-bootstrap/Button'
import { nanoid } from 'nanoid'
import isNil from 'lodash.isnil'

import './style/tagInput.scss'
import FilterAutoComplete from './FilterAutoComplete'
import Util from '../../../../utils/util'

function TagInput({
    label,
    setInputState,
    setFilter,
    testFunc,
    testAttr,
    initialValues = [],
    candidatePage,
    showTag=true
}) {
    const [tags, setTags] = useState([...initialValues])
    const [showInput, setShowInput] = useState(false)
    const inputRef = useRef()
    const buttonRef = useRef()
    
    useEffect(() => {
        if (!isNil(setFilter)) {
            console.assert(
                !(isNil(testFunc) && isNil(testAttr)),
                'TagInput requires either `testFunc` or `testAttr` to be provided'
            )
            testFunc = testFunc ?? getDefaultTestFunc(testAttr)
            
            setFilter(
                testAttr,
                tags.length === 0
                    ? null
                    : (candidate) => testFunc(candidate, tags)
            )
        }

        if (!isNil(setInputState)) {
            setInputState(
                testAttr,
                tags.map((t) => t.value)
            )
        }

        if (buttonRef.current) {
            buttonRef.current.focus()
        }
    }, [tags])

    useEffect(() => {
        if (inputRef.current) {
            inputRef.current.focus()
        }
    })

    useEffect(() => {
        setTags(initialValues)
    }, [initialValues.length])

    const handleInputKey = (e) => {
        if (e.which === 13 && e.target.value != ''){
            setTags(tags.concat({ id: nanoid(), value: e.target.value }))
            setShowInput(false)
        } else if (e.which === 13 && e.target.value === '') {
            setShowInput(false)
        }
    }

    const handleSelectName = (e, name) => {
        let val = ''
        if(name == "state") {
          val = e.state
        } else if(name == 'city') {
          val = (e.city+', '+e.state+', '+e.country)
        }
        if (e != '' && (e.company_name != undefined || (val && e.state != undefined|| e.city != undefined) || e.name !== undefined)){
            setTags(tags.concat({ id: nanoid(), value: (e.company_name || val || e.name)}))
            setShowInput(false)
        }
    }


    return (
        <div>
            {showTag &&
            <TagList
                tags={tags}
                removeTagFunc={(id) =>
                    setTags(tags.filter((tag) => tag.id !== id))
                }
                maxTagWidth={'100%'}
                shadows
            ></TagList>
            }
            {!showInput && (
                <Button
                    variant="grey"
                    ref={buttonRef}
                    onClick={() => {
                        showTag && setShowInput(true)
                    }}
                    style={{backgroundColor: candidatePage ? '#E6E9FC' : '' }}
                    className={`${candidatePage ? "btn btn-info p-1 rounded-circle btn-sm" : ''} ${showTag ? "" : "pointer-block"}` }
                >
                    {plusIcon()}
                </Button>
            )}
            {showInput &&  testAttr !== 'company_names' &&  testAttr !== 'companyNames' && testAttr !== 'city' && testAttr !== 'state'  && testAttr !== 'schools' && (
                    <div style={{ width: '100%' }}>
                        <input
                            type="text"
                            placeholder='Search...'
                            className="tagTextInput"
                            onKeyPress={handleInputKey}
                            onBlur={() => setShowInput(false)}
                            ref={inputRef}
                        />
                    </div>
                )}
            {showInput &&  (testAttr == 'company_names' || testAttr === 'companyNames' || testAttr == 'city' || testAttr == 'state' || testAttr == 'schools') && (
                    <FilterAutoComplete
                        getFilterValue={(e) => {
                            handleSelectName(e, testAttr)
                        }}
                        testAttr={testAttr}
                        onBlur={() => {setShowInput(false)}}
                    />
                )}
        </div>
    )
}

function getDefaultTestFunc(testAttr) {
    return (candidate, tags) => {
        return Util.attributePassesStringSetFilter(
            candidate,
            testAttr,
            tags.map((t) => t.value)
        )
    }
}

function plusIcon() {
    return (
        <svg
            width="27"
            height="27"
            fill="none"
            stroke="currentColor"
            strokeLinecap="round"
            strokeLinejoin="round"
            strokeWidth="2"
            className="css-i6dzq1"
            viewBox="0 0 24 24"
            style={{marginRight: '1px' }}
        >
            <path d="M12 5L12 19"></path>
            <path d="M5 12L19 12"></path>
        </svg>
    )
}

export default TagInput
