import React, {useEffect } from "react"
import Button from "react-bootstrap/Button"
import styled from 'styled-components'
import feather from "feather-icons"
import { nanoid } from "nanoid"

import Expander from "./common/Expander/Expander"
import TagInput from "./common/inputs/TagInput/TagInput"
import InputSection from "./common/inputs/InputSection/InputSection"
import FilterGroup from "./common/FilterGroup/FilterGroup"


export const W4text = styled.span`
    font-style: normal;
    font-weight: 400;
    font-size: ${(props) => props.size};
    color: ${(props) => props.color};
    display: flex;
    &:hover {
        color: inherit;
    }
`
export const Box = styled.div`
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 7px 0px;
    background: ${({ selected }) =>
        selected
            ? `linear-gradient(
            94.67deg,
            #4c68ff -1.19%,
            #6077f4 53.94%,
            #8185ff 102.59%
        )`
            : ''};
    border-radius: 6px;
    &:hover {
        background: linear-gradient(
            94.67deg,
            #4c68ff -1.19%,
            #6077f4 53.94%,
            #8185ff 102.59%
        );
        > ${W4text} {
            color: #ffffff !important;
        }
    }
    > ${W4text} {
        color: ${({ selected }) => (selected ? '#ffffff' : '')};
    }
`


const experienceYearsData = [
  {display:'<1 Year', value:'0-0'},
  {display:'1-2 Year', value:'1-2'},
  {display: '2-5 Year', value:'2-5'},
  {display:'5-10 Year', value:'5-10'},
  {display:'10+ Year', value:'10-30'},]

const FilterJob = ({
  filterStack,
  setStackFilter,
  handleSearch,
  handleReset,
  experienceYears,
  setExperienceYears,
}) => {
  useEffect(() => {
      feather.replace()
  })

  const setInputState = (attr, val) => {
      if (attr === 'city'){
        setStackFilter((lastFilterState) => ({
            ...lastFilterState,
            locations: val,
        }))
      }
      setStackFilter((lastFilterState) => ({
          ...lastFilterState,
          [attr]: val,
      }))
  }

  const handleSubmit = (e) => {
      e.preventDefault()
      handleSearch()
  }

  const handleResetFilters = () => {
      if (handleReset && typeof handleReset === 'function') {
          setStackFilter({
              companyNames: [],
              schools: [],
              skills: [],
              keywords: [],
          })
          handleReset()
      } else {
          resetFilterStack()
      }
  }

  const resetFilterStack = () => {
      window.location.replace(`/job_search`)
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
      <FilterGroup
          filterCount={activeFilterCount(filterStack)}
          handleResetFilters={handleResetFilters}
          experienceYearsCount={experienceYears}
      >
          <Expander
              label="Experience Years"
              expanded={experienceYears && experienceYears.length > 0}
          >
              <div>
                  {experienceYearsData.map((year, index) => (
                      <Box
                          onClick={() => {
                              setExperienceYears(year.value)
                          }}
                          key={index}
                          selected={year.value === experienceYears}
                      >
                          <W4text color="#474953" size="13px">
                              {year.display}
                          </W4text>
                      </Box>
                  ))}
              </div>
          </Expander>

          <Expander
              label="Company"
              expanded={
                  filterStack.companyNames &&
                  filterStack.companyNames.length > 0
              }
          >
              <InputSection>
                  <TagInput
                      setInputState={setInputState}
                      initialValues={
                          filterStack.companyNames
                              ? Array.isArray(filterStack.companyNames)
                                  ? filterStack.companyNames
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
                      testAttr="companyNames"
                  />
              </InputSection>
          </Expander>
          <Expander
              label="Skills"
              expanded={filterStack.skills && filterStack.skills.length > 0}
          >
              <InputSection>
                  <TagInput
                      setInputState={setInputState}
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
                  />
              </InputSection>
          </Expander>
          <Expander
              label="Location"
              expanded={
                  filterStack.locations && filterStack.locations.length > 0
              }
          >
              <InputSection>
                  <TagInput
                      setInputState={setInputState}
                      initialValues={
                          filterStack.locations
                              ? Array.isArray(filterStack.locations)
                                  ? filterStack.locations
                                        .filter((location) => location != '')
                                        .map((location) => {
                                            return {
                                                id: nanoid(),
                                                value: location,
                                            }
                                        })
                                  : []
                              : []
                      }
                      testAttr="city"
                  />
              </InputSection>
          </Expander>

          <Button className={'filterBtn'} onClick={handleSubmit}>
              Filter
          </Button>
          <Button className={'filterBtn ml-2'} onClick={handleResetFilters}>
              Clear
          </Button>
      </FilterGroup>
  )
}

export default FilterJob
