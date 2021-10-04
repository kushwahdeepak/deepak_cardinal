import React, { useState, useEffect } from 'react'
import AsyncSelect from "react-select/async";
import {Step3Context} from '../../../../context/Step3Context'
import {Step2Context} from '../../../../context/Step2Context'
import {Step1Context} from '../../../../context/Step1Context'
import {CustomModalContext} from '../../../../context/CustomModalContext'
import {Form, Button, Row, Col} from 'react-bootstrap'
import axios from 'axios'
import Alert from 'react-bootstrap/Alert'
import './styles/Jobs.scss'
import Select from 'react-select'
import {colourStyles} from '../Header/styles/Select.styles'
import Util from '../../../../utils/util';

function Step3({job}) {
  const modalBar = React.useContext(CustomModalContext)
  const [loading, setLoading] = useState()
  const [isLoading,setIsLoading] = useState({company:false,location:false,education:false})
  const [errorMessage, setErrorMessage] = useState('')
  const [industries, setIndustries] = useState([])
  const [locationPreferrenceSpecifyFilter, setLocationPreferrenceSpecifyFilter] = useState([]);
  const [educationPreferrenceSpecifyFilter, setEducationPreferrenceSpecifyFilter] = useState([]);
  const [companyPreferrenceSpecifyFilter, setCompanyPreferrenceSpecifyFilter] = useState([]);
  const [currentSpecify, setCurrentSpecify] = useState('')

  useEffect(() => {
      if (job?.prefered_industries) {
          setPreferredIndustry(job?.prefered_industries)
      }
      if (
          job?.company_names &&
          companyPreferrenceSpecifySelected.length === 0
      ) {
          const companies = job?.company_names.map((com) => {
              const name = Util.capitalize(com.company_name)
              return { value: com.id, label: name }
          })
          if (companies.length > 0) {
              setCompanyPreferrenceSpecifySelected(companies)
              checkIndustry('Specify')
          }
      }
      if (
          job?.school_names &&
          educationPreferrenceSpecifySelected.length === 0
      ) {
          const educations = job?.school_names?.map((education) => {
              const name = Util.capitalize(education.name)
              return { value: education.id, label: name }
          })
          if (educations.length > 0) {
              setEducationPreferrenceSpecifySelected(educations)
              checkEducation('Specify')
          }
      }
      if (
          job?.location_names &&
          locationPreferrenceSpecifySelected.length === 0
      ) {
          const locatons = job.location_names.map(({ id, state, city }) => {
              const capState = Util.capitalize(state)
              const capCity = Util.capitalize(city)
              return { value: id, label: `${capCity}, ${capState} (US)` }
          })
          if (locatons.length > 0) {
              setLocationPreferrenceSpecifySelected(locatons)
              checkLocation('Specify')
          }
      }
      if (job?.keywords || job?.skills) {
          const mustToKeyword = job?.keywords + ',' + job?.skills
          const mustToKeywordArray = [...new Set(mustToKeyword.split(','))]
          const mustToKeywordString = mustToKeywordArray.toString()
          setMustHaveKeyword(mustToKeywordString)
      }
      if (job?.nice_to_have_keywords || job?.niceToHaveSkills) {
          const naceToKeywords =
              job?.niceToHaveSkills + ',' + job?.nice_to_have_keywords
          const naceToKeywordsArray = [...new Set(naceToKeywords.split(','))]
          const niceToKeywordString = naceToKeywordsArray.toString()
          setNiceToHaveKeyword(niceToKeywordString)
      }

      if (job?.education_preference) {
          const edPreferrence = educationPreferrence
              ? educationPreferrence
              : job?.education_preference
          setEducationPreferrence(edPreferrence)
      }
      if (job?.company_preference) {
          const comPreferrence = companyPreferrence
              ? companyPreferrence
              : job?.company_preference
          setCompanyPreferrence(comPreferrence)
      }
      if (job?.location_preference) {
          const locPreferrence = locationPreferrence
              ? locationPreferrence
              : job?.location_preference
          setLocationPreferrence(locPreferrence)
      }
      const fetchIndustries = async () => {
          const lookupsUrl = '/signup/lookups'
          const responce = await axios.get(lookupsUrl).then((res) => {
              const industriesData = res.data.industries.map((industrie) => {
                  return { value: industrie.key, label: industrie.value }
              })
              setIndustries([...industriesData])
          })
      }
      fetchIndustries()
      modalBar.setJobStore(job)
  }, [])

  const handleKeyPress = async (value, callback,currentTarget) => {
      setCurrentSpecify(currentTarget)
      let url = ''
      if (currentSpecify == 'company') {
        setIsLoading({...isLoading,company:true})
          url = `/filter_candidate_on_company`
      } else if (currentSpecify == 'location') {
        setIsLoading({...isLoading,location:true})
          url = `/filter_candidate_on_location`
      } else if (currentSpecify == 'education') {
        setIsLoading({...isLoading,education:true})
          url = `/filter_candidate_on_education`
      }
      const formData = new FormData()
      formData.append('filter_word', value)
    
      const response = await axios.post(url, formData)
          .then((res) => res)
          .catch((error) => console.log(error))
      if (currentSpecify == 'company') {
          const companyPreferenceArray = response.data.filter.map((company) => {
              const name = Util.capitalize(company.company_name)
              return { value: company.id, label: name }
          })
          setCompanyPreferrenceSpecifyFilter(companyPreferenceArray)
          callback(companyPreferrenceSpecifyFilter)
          setIsLoading({ ...isLoading, company: false })
      } else if (currentSpecify == 'location') {
          const locationPreferrenceArray = response.data.filter.map(
              ({ id, state, city }) => {
                const capState = Util.capitalize(state)
                const capCity = Util.capitalize(city)
                  return { value: id, label: `${capCity}, ${capState} (US)` }
              }
          )
          setLocationPreferrenceSpecifyFilter(locationPreferrenceArray)
          callback(locationPreferrenceSpecifyFilter)
          setIsLoading({ ...isLoading, location: false })
      } else if (currentSpecify == 'education') {
          const educationPreferenceArray = response.data.filter.map(
              ({ id, name }) => {
                const capName = Util.capitalize(name)
                  return { value: id, label: capName }
              }
          )
          setEducationPreferrenceSpecifyFilter(educationPreferenceArray)
          callback(educationPreferrenceSpecifyFilter)
          setIsLoading({ ...isLoading, education: false })
      }
  }


  const checkEducation = (name) => {
    if(name !== "Specify"){
      setEducationPreferrenceSpecifySelected([])
    }
    setEducationPreferrence(name)
    setCurrentSpecify('education')
  }

  const checkIndustry = (name) => {
    if(name !== "Specify"){
      setCompanyPreferrenceSpecifySelected([])
    }
    setCompanyPreferrence(name)
    setCurrentSpecify('company')
  }

  const checkLocation = (name) => {
    if(name !== "Specify"){
      setLocationPreferrenceSpecifySelected([])
    }
    setLocationPreferrence(name)
    setCurrentSpecify('location')
  }

  const {
    title,
    location,
    description,
    musthave,
    nicetohave,
    emailStepOne,
    referrals,
    money,
    locationDepartment
  } = React.useContext(Step1Context)

  const {
    subject,
    email,
    sms,
  } = React.useContext(Step2Context)

  const {
    mustHaveKeyword = '',
    setMustHaveKeyword,
    niceToHaveKeyword = '',
    setNiceToHaveKeyword,
    preferredTitles,
    setPreferredTitles,
    experienceYears,
    setExperienceYears,
    educationPreferrence,
    setEducationPreferrence,
    companyPreferrence,
    setCompanyPreferrence,
    locationPreferrence, 
    setLocationPreferrence,
    preferredIndustry,
    setPreferredIndustry,
    companyPreferrenceSpecifySelected,
    setCompanyPreferrenceSpecifySelected,
    educationPreferrenceSpecifySelected,
    setEducationPreferrenceSpecifySelected,
    locationPreferrenceSpecifySelected,
    setLocationPreferrenceSpecifySelected,
  } = React.useContext(Step3Context)

useEffect(() => {
  if(nicetohave){
    const niceToKayword = nicetohave + ',' + niceToHaveKeyword
    const  niceToHaveKeywordArray =[...new Set(niceToKayword.split(','))]
    const niceToHaveKeywordString = niceToHaveKeywordArray.toString()
    setNiceToHaveKeyword(niceToHaveKeywordString.replace(/,\s*$/, ""))
  }


  if(musthave){
    const mustToKeyword = musthave + ',' + mustHaveKeyword
    const mustTohaveKeywordArray = [...new Set(mustToKeyword.split(','))]
    const mustToKeywordString = mustTohaveKeywordArray.toString()
    setMustHaveKeyword(mustToKeywordString.replace(/,\s*$/, ""))
  }
}, [nicetohave,musthave])

  const experienceYearsData = [
  {display:'<1 Year', value:'0'},
  {display:'1-2 Year', value:'1'},
  {display: '2-5 Year', value:'2'},
  {display:'5-10 Year', value:'3'},
  {display:'10+ Year', value:'4'},]

    const selectCompanyPrefferrenceSpecify = (selectedOptions) => {
      setCompanyPreferrenceSpecifySelected([...selectedOptions.map( ({value, label}) =>({value: value, label:label}) )])
    }


    const selectLocationPrefferrenceSpecify = (selectedOptions) => {
        setLocationPreferrenceSpecifySelected([...selectedOptions.map( ({value, label}) =>({value: value, label:label}) )])
    }

    const selectEducationPrefferrenceSpecify = (selectedOptions) => {
      setEducationPreferrenceSpecifySelected([...selectedOptions.map( ({value, label}) =>({value: value, label:label}) )])
    }

    const handleSubmitResponse = () => {
      let companySpecifyIds = []
      let locationSpecifyIds = []
      let educationSpecifyIds = []
      
      companyPreferrenceSpecifySelected.length > 0 && companyPreferrenceSpecifySelected.map((e)=> { companySpecifyIds.push(e.value) })
      locationPreferrenceSpecifySelected.length > 0 && locationPreferrenceSpecifySelected.map((e)=> { locationSpecifyIds.push(e.value) })
      educationPreferrenceSpecifySelected.length > 0 && educationPreferrenceSpecifySelected.map((e)=> { educationSpecifyIds.push(e.value) })
      const payload = {
        name: title,
        location: location.label,
        description: description,
        skills: musthave,
        nice_to_have_skills: nicetohave,
        notificationemails: emailStepOne,
        referral_candidate: referrals,
        referral_amount: money,
        email_campaign_subject: subject,
        email_campaign_desc: email,
        sms_campaign_desc: sms,
        keywords: mustHaveKeyword,
        nice_to_have_keywords: niceToHaveKeyword,
        department: locationDepartment,
        experience_years: experienceYears,
        prefered_titles: preferredTitles,
        prefered_industries: preferredIndustry,
        school_names: (educationPreferrence == 'Specify' && educationSpecifyIds.length > 0) ? educationSpecifyIds : '',
        company_names: (companyPreferrence == 'Specify' && companySpecifyIds.length > 0) ? companySpecifyIds : '',
        location_names: (locationPreferrence == 'Specify' && locationSpecifyIds.length > 0) ? locationSpecifyIds : '',
        education_preference: (educationPreferrence == 'Specify') ? '' : educationPreferrence,
        company_preference: (companyPreferrence == 'Specify') ? '' : companyPreferrence,
        location_preference: (locationPreferrence == 'Specify' ) ? '' : locationPreferrence,
      }
      modalBar.setBarState({activeCreateForm: 3})
      modalBar.setLoaderResponse(loading)
      modalBar.setTesting(payload)
      modalBar.setErrorMessageCustom(errorMessage)
      
  }

  return(

    <Form>
      <Form.Row>
        {errorMessage && (
          <Alert
              variant="danger"
              onClose={() => setErrorMessage(null)}
              dismissible
          >
              {errorMessage}
          </Alert>
        )}
         <Col xs={12}>
          <Form.Group>
            <Form.Label>Must have keyword <span className="infoSpan">(Separated By Comma)</span></Form.Label>
            <Form.Control as="textarea"
              className="form-control"
              type="textarea"
              onChange={e => {
                e.target.value.trim() ? setMustHaveKeyword(e.target.value) : setMustHaveKeyword('')
              }}
              rows={4}
              value={mustHaveKeyword}
            />
          </Form.Group>
        </Col>
        <Col xs={12}>
          <Form.Group>
            <Form.Label>Nice to have keywords <span className="infoSpan">(Separated By Comma)</span></Form.Label>
            <Form.Control as="textarea" rows={3}
              className="form-control"
              onChange={e => {
                e.target.value.trim() ? setNiceToHaveKeyword(e.target.value) : setNiceToHaveKeyword('')
              }}
              rows={4}
              value={niceToHaveKeyword}
            />
          </Form.Group>
        </Col>
        <Col xs={6}>
          <Form.Group >
            <Form.Label>Education preferences</Form.Label>
            <Form.Check
              type="checkbox"
              label="Top 25 universities"
              name="formHorizontalRadios"
              id="formHorizontalRadios1"
              onChange={e => {
                checkEducation('Top 25 universities')
              }}
              checked={educationPreferrence === "Top 25 universities" ? true : false}
            />
            
            <Form.Check
              type="checkbox"
              label="Top 100 universities"
              name="formHorizontalRadios"
              id="formHorizontalRadios2"
              onChange={e => {
                checkEducation('Top 100 universities')
              }}
              checked={educationPreferrence === "Top 100 universities" ? true : false}
            />
            <Form.Check
              type="checkbox"
              label="No preference"
              name="formHorizontalRadios"
              id="formHorizontalRadios3"
              onChange={e => {
                checkEducation('No preference')
              }}
              checked={educationPreferrence === "No preference" ? true : false}
            />
            <Form.Check
              type="checkbox"
              label="Specify"
              name="formHorizontalRadios"
              id="formHorizontalRadios4"
              onChange={e => {
                checkEducation('Specify')
              }}
              checked={educationPreferrence === "Specify"}
            />
            {educationPreferrence === "Specify" &&
              <AsyncSelect
              isMulti
              isLoading={isLoading.education}
              isClearable={true}
              loadOptions={(inputValue, callback)=>handleKeyPress(inputValue, callback, 'education')}
              value={educationPreferrenceSpecifySelected}
              onChange={selectEducationPrefferrenceSpecify}
              placeholder={'Search for University'}
            />
           }
          </Form.Group>
        </Col>
        <Col xs={6}>
          <Form.Group >
            <Form.Label>Company preferences</Form.Label>
            <Form.Check
              type="checkbox"
              label="Industry leaders"
              name="formmHorizontalRadios"
              id="formmHorizontalRadios1"
              onChange={e => {
                checkIndustry("Industry leaders")
              }}
              checked={companyPreferrence === "Industry leaders" ? true : false}
            />
            <Form.Check
              type="checkbox"
              label="Fortune 500"
              name="formmHorizontalRadios"
              id="formmHorizontalRadios2"
              onChange={e => {
                checkIndustry("Fortune 500")
              }}
              checked={ companyPreferrence === "Fortune 500"}
            />
            <Form.Check
              type="checkbox"
              label="Start-ups"
              name="formmHorizontalRadios"
              id="formmHorizontalRadios3"
              onChange={e => {
                checkIndustry("Start-ups")
              }}
              checked={ companyPreferrence === "Start-ups"}
            />
            <Form.Check
              type="checkbox"
              label="No preference"
              name="formmHorizontalRadios"
              id="formmHorizontalRadios4"
              onChange={e => {
                checkIndustry("No preference")
              }}
              checked={companyPreferrence === "No preference"}
            />
            <Form.Check
              type="checkbox"
              label="Specify"
              name="formmHorizontalRadios"
              id="formmHorizontalRadios5"
              onChange={e => {
                checkIndustry("Specify")
              }}
              checked={companyPreferrence === "Specify"}
            />
            {companyPreferrence === "Specify" &&
            <AsyncSelect
              isMulti
              isLoading={isLoading.company}
              isClearable={true}
              loadOptions={(inputValue, callback)=>handleKeyPress(inputValue, callback, 'company')}
              value={companyPreferrenceSpecifySelected}
              onChange={selectCompanyPrefferrenceSpecify}
              placeholder={'Search for Company'}
            />

           }
          </Form.Group>
        </Col>
        <Col xs={6}>
          <Form.Group >
            <Form.Label >Location prefrence</Form.Label>
            <Form.Check
              label="Anywhere in US"
              type="checkbox"
              name="formmmHorizontalRadios"
              id="formmmHorizontalRadios1"
              onClick={e => {
                checkLocation("Anywhere in US")
              }}
              checked={locationPreferrence === "Anywhere in US"}
            />
            <Form.Check
              label="Specify"
              type="checkbox"
              name="formmmHorizontalRadios"
              id="formmmHorizontalRadios2"
              onClick={e => {

                checkLocation("Specify")
              }}
              checked={locationPreferrence === "Specify"}
            />
            {locationPreferrence === "Specify" &&
            <AsyncSelect
              isMulti
              isLoading={isLoading.location}
              isClearable={true}
              loadOptions={(inputValue, callback)=>handleKeyPress(inputValue, callback, 'location')}
              value={locationPreferrenceSpecifySelected}
              onChange={selectLocationPrefferrenceSpecify}
              placeholder={'Search for Location'}
            />

            }
          </Form.Group>
        </Col>
        <Col xs={6}>
          <Form.Group>
              <Form.Label>Experience</Form.Label>
              <div className="dropdown-icon"></div>
              <Form.Control
              as="select"
              custom
              className="form-control"
                onChange={e => {
                    setExperienceYears(e.target.value)
                }}
                value={experienceYears}
                defaultValue={job?.experience_years ? job?.experience_years : experienceYears}
              >
               {experienceYearsData && experienceYearsData.map((a, index) => {
                  return (
                    <option key ={index} value={a.value}>{a.display}</option>
                  )
                })}
              </Form.Control>
            </Form.Group>
          </Col>
          <Col xs={12}>
            <Form.Group>
              <Form.Label>Preferred Titles</Form.Label>
              <Form.Control as="textarea" rows={3}
                className="form-control"
                placeholder="seprated by comma"
                onChange={e => {
                  e.target.value.trim() ? setPreferredTitles([e.target.value]) : setPreferredTitles('')
                }}
                rows={4}
                value={preferredTitles}
                defaultValue={job?.prefered_titles ? job.prefered_titles : preferredTitles}
              />
            </Form.Group>
        </Col>
        <Col xs={6}>
            <Form.Label>Preferred Industries</Form.Label>
              <Select
                className="basic-single"
                classNamePrefix="select"
                isSearchable={true}
                styles={colourStyles}
                name="color"
                onChange={(event) => setPreferredIndustry(event.value)}
                options={industries}
                value={
                  preferredIndustry
                        ? industries.filter(
                              (industrie) =>
                                  industrie.value === preferredIndustry
                          )
                        : industries[0]
                }
              />
        </Col>
      </Form.Row>
      
    <Button
      variant="primary"
      style={{
        margin: 0,
      }}
      onClick={()=> handleSubmitResponse()}
    >
      Next
    </Button>
  </Form>
  )
}

export default Step3;