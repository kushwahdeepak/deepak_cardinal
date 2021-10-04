import feather from 'feather-icons'
import { nanoid } from 'nanoid'
import _ from 'lodash'

import Expander from '../../common/Expander/Expander'
import TagInput from '../../common/inputs/TagInput/TagInput'
import MultiBooleanInput from '../../common/inputs/MultiBooleanInput/MultiBooleanInput'
import InputSection from '../../common/inputs/InputSection/InputSection'
import BooleanInput from '../inputs/BooleanInput/BooleanInput'
import RadioInput from '../inputs/RadioInput/RadioInput'
import FilterGroup from '../../common/FilterGroup/FilterGroup'
import React, { useState, useEffect } from 'react'
import Button from 'react-bootstrap/Button'
import isNil from 'lodash.isnil'
import './style/FilterStack.scss'

const FilterStack = ({ filterStack, currentOrganization, setFilterData, memberOrganization, handleSearch, candidatePage, setFilterStack, emptyFilter, closeFunc, jobId}) => {
    const userBelongsToCT = currentOrganization?.name === window.ch_const.ct_org_name

    const subOrgBelongsToCT = memberOrganization?.name === window.ch_const.ct_org_name

    useEffect(() => {
        feather.replace()
    })
    const [checked, setChecked] = useState(emptyFilter)
    const manualSearch = !isNil(handleSearch)

    const handleSubmit = (e) => {
        e.preventDefault()
        handleSearch()
    }

    const resetFilterStack = (e) => {
      e.preventDefault();
      const filter = {...emptyFilter}
      filter.keyword = filterStack.keyword
      setChecked(filter)
      setFilterStack(filter)
      closeFunc()
    }

    const setCheckBox = (attr,val) => {
        const newBoolStack = { ...checked, [attr]: val }
     if(!_.isEqual(checked,newBoolStack)) {
        setChecked(newBoolStack)
     }
    }

    function activeFilterCount(filters) {
        return Object.keys(filters)
            .map((key) => {
                if (Array.isArray(filterStack[key]))
                    return filterStack[key].length > 0 ? 1 : 0
                else if (typeof filterStack[key] === 'boolean')
                    return filterStack[key] ? 1 : 0
                else return 0
            })
            .reduce((acc, current) => acc + current, 0)
    }

    return (

        <FilterGroup candidatePage={candidatePage} filterCount={activeFilterCount(filterStack)}>

            <Expander
                label="Recruiter Activity"
                expanded={
                    filterStack.topSchool ||
                    filterStack.topCompany ||
                    filterStack.active
                }
                candidatePage={candidatePage}
            >
                <InputSection>
                    <BooleanInput
                        setInputState={setFilterData}
                        label="Top school"
                        testAttr="top_school"
                        initialValue={filterStack.top_school}
                        checked={checked.top_school}
                        setCheckBox={setCheckBox}
                    />
                    <BooleanInput
                        setInputState={setFilterData}
                        label="Top company"
                        testAttr="top_company"
                        initialValue={filterStack.top_company}
                        checked={checked.top_company}
                        setCheckBox={setCheckBox}
                    />
                    { (userBelongsToCT || subOrgBelongsToCT) && 
                        <BooleanInput
                            setInputState={setFilterData}
                            label="Active"
                            testAttr="active"
                            initialValue={filterStack.active}
                            checked={checked.active}
                            setCheckBox={setCheckBox}
                        />
                    }
                </InputSection>
            </Expander>
            <Expander
                label="Company"
                expanded={
                    filterStack.companyNames &&
                    filterStack.companyNames.length > 0
                }
                candidatePage={candidatePage}
            >
                <InputSection>
                    <TagInput
                        setInputState={setFilterData}
                        initialValues={
                            filterStack.company_names
                                ? Array.isArray(filterStack.company_names)
                                    ? filterStack.company_names
                                          .filter((company) => company != '')
                                          .map((company) => {
                                              return {
                                                  id: nanoid(),
                                                  value: company,
                                              }
                                          })
                                    : []
                                : []
                        }
                        testAttr="company_names"
                        candidatePage={candidatePage}
                    />
                </InputSection>
            </Expander>
            <Expander
                label="Education"
                expanded={
                    (filterStack.schools && filterStack.schools.length > 0) ||
                    (filterStack.disciplines &&
                        filterStack.disciplines.length > 0) ||
                    (filterStack.degrees && filterStack.degrees.length > 0)
                }
                candidatePage={candidatePage}

            >
                <InputSection label="School">
                    <TagInput
                        setInputState={setFilterData}
                        initialValues={
                            filterStack.schools
                                ? Array.isArray(filterStack.schools)
                                    ? filterStack.schools
                                          .filter((school) => school != '')
                                          .map((school) => {
                                              return {
                                                  id: nanoid(),
                                                  value: school,
                                              }
                                          })
                                    : []
                                : []
                        }
                        testAttr="schools"
                        candidatePage={candidatePage}
                    />
                </InputSection>
                {!jobId && location.pathname != "/people_searches/new" ? 
                <InputSection label="Discipline (major)">
                    <TagInput
                        setInputState={setFilterData}
                        initialValues={
                            filterStack.disciplines
                                ? Array.isArray(filterStack.disciplines)
                                    ? filterStack.disciplines
                                          .filter(
                                              (discipline) => discipline != ''
                                          )
                                          .map((discipline) => {
                                              return {
                                                  id: nanoid(),
                                                  value: discipline,
                                              }
                                          })
                                    : []
                                : []
                        }
                        testAttr="disciplines"
                        candidatePage={candidatePage}
                    />
                </InputSection>: ""}
                {!jobId ? 
                <InputSection label="Degrees">
                    <MultiBooleanInput
                        setInputState={setFilterData}
                        label="Degrees"
                        checkboxInfo={[
                            {
                                label: window.ch_const.degree_bachelors,
                                option: window.ch_const.degree_bachelors,
                            },
                            {
                                label: window.ch_const.degree_masters,
                                option: window.ch_const.degree_masters,
                            },
                            {
                                label: window.ch_const.degree_doctorate,
                                option: window.ch_const.degree_doctorate,
                            },
                        ]}
                        initialValues={filterStack.degrees}
                        testAttr="degrees"
                        candidatePage={candidatePage}
                    />
                </InputSection> : ""}
            </Expander>
            <Expander
                label="Location"
                expanded={
                    filterStack.locations && filterStack.locations.length > 0
                }
                candidatePage={candidatePage}
            >
                <InputSection>
                  <div>{"State"}</div>
                    <TagInput
                        setInputState={setFilterData}
                        initialValues={
                            filterStack.state
                                ? Array.isArray(filterStack.state)
                                    ? filterStack.state
                                          .filter((stateName) => stateName != '')
                                          .map((stateName) => {
                                              return {
                                                  id: nanoid(),
                                                  value: stateName,
                                              }
                                          })
                                    : []
                                : []
                        }
                        testAttr="state"
                        candidatePage={candidatePage}
                        showTag={filterStack?.city && filterStack?.city.length == 0 ? true : false}
                    />
                    <div>{"City"}</div>
                    <TagInput
                        setInputState={setFilterData}
                        initialValues={
                            filterStack.city
                                ? Array.isArray(filterStack.city)
                                    ? filterStack.city
                                          .filter((cityName) => cityName != '')
                                          .map((cityName) => {
                                              return {
                                                  id: nanoid(),
                                                  value: cityName,
                                              }
                                          })
                                    : []
                                : []
                        }
                        testAttr="city"
                        candidatePage={candidatePage}
                        showTag={filterStack?.state && filterStack?.state.length == 0 ? true : false}
                    />
                </InputSection>
            </Expander>
            <Expander
              label="Skills"
              expanded={filterStack.skills && filterStack.skills.length > 0}
              candidatePage={candidatePage}
            >
              <InputSection>
                <TagInput
                  setInputState={setFilterData}
                  initialValues={
                    filterStack.skills
                      ? Array.isArray(filterStack.skills)
                        ? filterStack.skills
                            .filter((skill) => skill != '')
                            .map((skill) => {
                              return {
                                id: nanoid(),
                                value: skill,
                              }
                            })
                        : []
                      : []
                  }
                  testAttr="skills"
                  candidatePage={candidatePage}
                />
              </InputSection>
            </Expander>
            <Expander
                label="Job Title"
                expanded={
                    filterStack.titles && filterStack.titles.length > 0
                }
                candidatePage={candidatePage}
            >
                <InputSection>
                    <TagInput
                        setInputState={setFilterData}
                        initialValues={
                            filterStack.titles
                                ? Array.isArray(filterStack.titles)
                                    ? filterStack.titles
                                          .filter((titles) => titles != '')
                                          .map((titles) => {
                                              return {
                                                  id: nanoid(),
                                                  value: titles,
                                              }
                                          })
                                    : []
                                : []
                        }
                        testAttr="titles"
                        candidatePage={candidatePage}
                    />
                </InputSection>
            </Expander>
            <Expander
                label="Phone number"
                expanded={filterStack.phoneNumberAvailable}

                candidatePage={candidatePage}
            >
                <InputSection>
                    <BooleanInput
                        setInputState={setFilterData}
                        label="Phone number available"
                        testAttr="phone_number_available"
                        initialValue={filterStack.phone_number_available}
                        checked={checked.phone_number_available}
                        setCheckBox={setCheckBox}
                    />
                </InputSection>
            </Expander>
            <Expander
                label="Emails"
                expanded={filterStack.emails && filterStack.emails.length > 0}

                candidatePage={candidatePage}

            >
                <InputSection>
                    <TagInput
                        setInputState={setFilterData}
                        initialValues={
                            filterStack.emails
                                ? Array.isArray(filterStack.emails)
                                    ? filterStack.emails
                                          .filter((email) => email != '')
                                          .map((email) => {
                                              return {
                                                  id: nanoid(),
                                                  value: email,
                                              }
                                          })
                                    : []
                                : []
                        }
                        testAttr="emails"
                        candidatePage={candidatePage}
                    />
                </InputSection>
                <RadioInput
                    setInputState={setFilterData}
                    radioInfo={['Personal', 'Company']}
                    initialValue={filterStack.email_type}
                    testAttr="email_type"
                />
            </Expander>
            <Expander
                label="Names"
                expanded={filterStack.names && filterStack.names.length > 0}

                candidatePage={candidatePage}
            >
                <InputSection>
                    <TagInput
                        setInputState={setFilterData}
                        initialValues={
                            filterStack.names
                                ? Array.isArray(filterStack.names)
                                    ? filterStack.names
                                          .filter((name) => name != '')
                                          .map((name) => {
                                              return {
                                                  id: nanoid(),
                                                  value: name,
                                              }
                                          })
                                    : []
                                : []
                        }
                        testAttr="names"
                        candidatePage={candidatePage}
                    />
                </InputSection>
            </Expander>
            <button className='clear-filter' onClick={(e) => resetFilterStack(e)}>  Clear Filters <i className='icon-sm' data-feather='x' /></button>
        </FilterGroup>
    )
}

export default FilterStack
