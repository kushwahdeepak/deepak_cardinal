import React, { useState, useEffect } from 'react'
import PropTypes from 'prop-types'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import axios from 'axios'
import './style/FilterAutocomplete.scss'

const FilterAutocomplete = ({ getFilterValue, testAttr, onBlur }) => {
    const [searchLoc, setSearchLoc] = useState('')
    const [searchValue, setSearchValue] = useState('')
    const [state, setState] = useState({
        showSuggestions: false,
        suggestions: [],
        selectedSearchValue: '',
    })
    const selectRef = React.createRef()
    const { showSuggestions, suggestions, selectedSearchValue } = state

    const getSearchValue = async (searchTerm) => {
        let url
        if (testAttr == 'company_names') {
            url = '/filter_candidate_on_company'
        } else if (testAttr == 'schools'){
            url = '/filter_candidate_on_education'
        } else if (testAttr == 'city'){
            url = '/filter_candidate_on_location?flag=true'
        } else if (testAttr === 'companyNames'){
            url = `/organizations/get_organization?search=${searchTerm}`
        } else {
            url = '/filter_candidate_on_location'
        }
        const CSRF_Token = document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute('content')

        try {
            let response
            if (testAttr === 'companyNames') {
                 response = await axios.get(url)
                console.log(response)
                let organizations = response.data.organizations
                console.log(organizations)
                setState((prevState) => ({
                    ...prevState,
                    suggestions: [...organizations],
                    showSuggestions: true,
                }))
            } else {
                 response = await axios.post(
                    url,
                    { filter_word: searchTerm },
                    {
                        headers: {
                            'content-type': 'application/json',
                            'X-CSRF-Token': CSRF_Token,
                        },
                    }
                )
                setState((prevState) => ({
                    ...prevState,
                    suggestions: response.data.filter,
                    showSuggestions: true,
                }))
            }
        } catch (e) {
            console.log(e.message, 'error')
        }
    }

    const handleSelectLocation = (e) => {
        setSearchValue(e.target.value)
    }

    const handleOnBlur = (e) => {
        if(!e.target.value){
            onBlur()
        }
    }

    const handleFileterValue = (testAttr, suggestion) => {
        switch(testAttr){
            case 'company_names':
               return suggestion.company_name
            case 'state':   
                return suggestion.state
            case 'city':   
                 return suggestion.city +
                ', ' +
                suggestion.state +
                ', ' +
                suggestion.country
            case 'schools':
                return suggestion.name
            case 'companyNames':
                return suggestion.name
            default: 
                break     
        }

    }

    useEffect(() => {
        getFilterValue(selectedSearchValue)
        setSearchValue('')
    }, [selectedSearchValue])

    let suggestionsListComponent
    if (showSuggestions && searchLoc) {
        if (suggestions.length) {
            suggestionsListComponent = (
                <select
                    ref={selectRef}
                    className="suggestions"
                    value={searchValue}
                    size={
                        suggestions.length < 5
                            ? suggestions.length == 1
                                ? 2
                                : suggestions.length
                            : 5
                    }
                    style={{width:`${testAttr === `companyNames` ? '134px' : '160px' }`}}
                    onChange={(e) => {
                        handleSelectLocation(e)
                    }}
                    onKeyDown={(e) => {
                        if (e.key === 'Enter') {
                            setSearchValue(e.target.value)
                            setSearchLoc(
                                e.target.options[e.target.selectedIndex].text
                            )
                            setState({
                                showSuggestions: false,
                                suggestions: [],
                                selectedSearchValue: e.target.value,
                            })
                        }
                    }}
                >
                    {suggestions.map((suggestion, index) => {
                        return (
                            <option
                                key={suggestion.id}
                                onClick={(e) => {
                                    setSearchValue(suggestion.id)
                                    setSearchLoc(handleFileterValue(testAttr, suggestion))
                                    setState({
                                        showSuggestions: false,
                                        suggestions: [],
                                        selectedSearchValue: suggestion,
                                    })
                                }}
                                value={suggestion.id}
                                style={{ cursor: 'pointer' }}
                            >
                                {handleFileterValue(testAttr, suggestion)}
                            </option>
                        )
                    })}
                </select>
            )
        } else {
            suggestionsListComponent = (
               <div className="no-suggestions" />
            )
        }
    }

    return (
        <div className="wrapper">
            <Row style={{ margin: '0px' }}>
                <Col style={{ padding: '0', margin: '0px' }}>
                    <input
                        className="input search_text"
                        type="text"
                        id="location_search"
                        autoComplete="off"
                        onBlur={(e)=> handleOnBlur(e)}
                        onChange={(e) => {
                            getSearchValue(e.target.value)
                            setSearchLoc(e.target.value)
                        }}
                        placeholder='Search...'
                        onKeyDown={(e) => {
                            if (e.key === 'ArrowDown') {
                                if (selectRef.current) {
                                    selectRef.current.focus()
                                }
                            }
                            if (e.key === 'Enter') {
                                e.preventDefault()
                                e.stopPropagation()
                                if (selectRef.current) {
                                    const selectedOption =
                                        selectRef.current.options[0]
                                    setSearchValue(selectedOption.value)
                                    setSearchLoc(selectedOption.text)
                                    setState({
                                        showSuggestions: false,
                                        suggestions: [],
                                        selectedSearchValue: selectedOption.value,
                                    })
                                }
                            }
                        }}
                        value={searchLoc }
                        autoFocus
                    />
                    {suggestionsListComponent}
                </Col>
            </Row>
        </div>
    )
}

FilterAutocomplete.propTypes = {
    getFilterValue: PropTypes.func.isRequired,
}

export default FilterAutocomplete
