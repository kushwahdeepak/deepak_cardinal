import React, { useState, useEffect } from 'react'
import PropTypes from 'prop-types'
import axios from 'axios'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import './styles/LocationAutocomplete.scss'

const LocationAutocomplete = ({ getLocationId,pageName, locationValue, setJobLocation }) => {
    const [searchLoc, setSearchLoc] = useState('')
    const [locationId, setLocationId] = useState('')
    const [state, setState] = useState({
        showSuggestions: false,
        suggestions: [],
        selectedLocationId: '',
    })

    const selectRef = React.createRef()

    const { showSuggestions, suggestions, selectedLocationId } = state

    const getLocationIndex = async (searchTerm) => {
        const CSRF_Token = document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute('content')

        try {
            const response = await axios.post(
                '/locations/search',
                { location: searchTerm },
                {
                    headers: {
                        'content-type': 'application/json',
                        'X-CSRF-Token': CSRF_Token,
                    },
                }
            )

            setState((prevState) => ({
                ...prevState,
                suggestions: response.data.locations,
                showSuggestions: true,
            }))
        } catch (e) {
            console.log(e.message, 'error')
        }
    }

    const handleSelectLocation = (e) => {
        setLocationId(e.target.value)
    }

    useEffect(() => {
        getLocationId(selectedLocationId)
        setLocationId('')
    }, [selectedLocationId])

    let suggestionsListComponent

    if (showSuggestions && searchLoc) {
        if (suggestions.length) {
            suggestionsListComponent = (
                <select
                    ref={selectRef}
                    className="suggestions"
                    value={locationId}
                    size={
                        suggestions.length < 5
                            ? suggestions.length == 1
                                ? 2
                                : suggestions.length
                            : 5
                    }
                    onChange={(e) => {
                        handleSelectLocation(e)
                    }}
                    onKeyDown={(e) => {
                        if (e.key === 'Enter') {
                            setLocationId(e.target.value)
                            setSearchLoc(
                                e.target.options[e.target.selectedIndex].text
                            )
                            setState({
                                showSuggestions: false,
                                suggestions: [],
                                selectedLocationId: e.target.value,
                            })
                        }
                    }}
                >
                    {suggestions.map((suggestion, index) => {
                        const text =
                            suggestion.state +
                            ', ' +
                            suggestion.country +
                            ', ' +
                            suggestion.city
                        return (
                            <option
                                key={suggestion.id}
                                onClick={(e) => {
                                    setLocationId(suggestion.id)
                                    setSearchLoc(text)
                                    setState({
                                        showSuggestions: false,
                                        suggestions: [],
                                        selectedLocationId: suggestion.id,
                                    })
                                }}
                                value={suggestion.id}
                                style={{ cursor: 'pointer' }}
                            >
                                {text}
                            </option>
                        )
                    })}
                </select>
            )
        } else {
            suggestionsListComponent = (
                <div className="no-suggestions">
                    <em>No suggestions available.</em>
                </div>
            )
        }
    }
    
    return (
        <div className="wrapper">
             <Row>
                <Col xs={pageName ? 12 : 4}>
                    <label className="location_search" htmlFor="location_search">
                        <span className="label">Location</span>
                    </label>
                </Col>
                <Col xs={pageName ? 12 : 8}>
                <input
                    className="input location_search_text"
                    type="text"
                    id="location_search"
                    autoComplete="off"
                    onChange={(e) => {
                        getLocationIndex(e.target.value)
                        setSearchLoc(e.target.value)
                        setState({
                            showSuggestions: false,
                            suggestions: [],
                            selectedLocationId: '',
                        })
                        pageName ? setJobLocation(e.target.value) : ''
                    }}
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
                                setLocationId(selectedOption.value)
                                setSearchLoc(selectedOption.text)
                                setState({
                                    showSuggestions: false,
                                    suggestions: [],
                                    selectedLocationId: selectedOption.value,
                                })
                            }
                        }
                    }}
                    value={locationValue && searchLoc ?  searchLoc  : searchLoc ? searchLoc : locationValue }
                />
                {suggestionsListComponent}
                </Col>
            </Row>
        </div>
    )
}

LocationAutocomplete.propTypes = {
    getLocationId: PropTypes.func.isRequired,
}

export default LocationAutocomplete
