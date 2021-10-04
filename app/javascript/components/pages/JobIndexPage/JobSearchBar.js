import React, { useState, useEffect } from 'react'
import { nanoid } from 'nanoid'
import './styles/JobIndexPage.scss'
import LocationAutocomplete from '../../common/LocationAutocomplete/LocationAutocomplete'
const formLabelsData = [
    {
        fieldLabel: 'Title',
        fieldType: 'text',
        fieldRequired: false,
        fieldId: nanoid(),
        controlName: 'title',
    },
    {
        fieldLabel: 'Location',
        fieldType: 'text',
        fieldRequired: false,
        fieldId: nanoid(),
        controlName: 'location',
    }
]
const JobSearchBar = ({setJobLocation, setJobTitle, jobSearch, handleFilter, jobTitle, jobLocation}) => {

    if (jobSearch) {
        useEffect(() => {
            if ((jobSearch && jobSearch.title) || jobSearch.locations) {
                setJobTitle(jobSearch.title)
                setJobLocation(jobSearch.locations)
            }
        }, [jobSearch.title, jobSearch.locations])
    }
    const renderFormField = ({
        fieldType,
        fieldLabel,
        fieldRequired,
        fieldId,
        controlName
    }) => {
        return (
            <>
            {controlName === 'location' ?
            <div className="col-md-5">
                <LocationAutocomplete
                    key={fieldId}
                    getLocationId={(locationId) => {
                        setJobLocation(locationId)
                    }}
                    locationValue={jobLocation}
                    pageName='jobSearch'
                    setJobLocation={setJobLocation}
                />
            </div>
            :
            <div className="col-md-5" key={fieldId}>
                <label htmlFor={fieldId} className="new-job-form__label">
                    <span
                        className={"new-job-form__field-title"}
                    >
                        {fieldLabel}
                    </span>
                </label>
                    {fieldType === 'text' && (
                        <input
                            required={fieldRequired}
                            className="new-job-form__input"
                            type="text"
                            id={fieldId}
                            value={jobTitle}
                            onChange={(event) =>
                                setJobTitle(event.target.value)
                            }
                        />
                    )}
            </div>
            }
            </>
        )
    }
    return (
        <div className="jobs-filter-page">
            <div className="container-filter">
                <div className="row">
                    <div className="col">
                        <div className="row">
                            {formLabelsData.map((formItem) =>
                                renderFormField(formItem)
                            )}
                            <div className="col-md-2">
                                <button
                                    type="submit"
                                    className="submit-new-job-form job-form"
                                    onClick={handleFilter}
                                >
                                    <span>Find Jobs</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    )
}
export default JobSearchBar
