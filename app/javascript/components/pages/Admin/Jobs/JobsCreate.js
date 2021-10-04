import React, { useState,useEffect, useReducer, useContext } from 'react'
import { Formik } from 'formik'
import * as Yup from 'yup'
import moment from 'moment'
import { H1, StyledForm, Label } from '../styles/UserManagementEditPage.styled'
import TextInput from '../shared/TextInput'
import Select from '../shared/Select'
import Button from '../../SignupPage/Button'
import { makeRequest } from '../../../common/RequestAssist/RequestAssist'
import { Row, Col } from 'react-bootstrap'
import AsyncSelect from "react-select/async";
import RedioInput from '../shared/RadioInput'
import CreatableSelect from 'react-select/creatable';
import { reducer, JobStoreContext } from '../../../../stores/Admin/JobStore'
import { Editor } from '@tinymce/tinymce-react';
import '../styles/Jobs.scss'

const JobsCreate = ({job, organization, industry, url, method, message}) => {
   
    const [isLoading, setLoading] = useState(false)
    const [inputValue, setInputValue] = useState('')
    const [selectedOrganization, setSelectedOrganization]  = useState([{value: organization.id, label: organization.name}])
    const [member_options, setOptions] = useState([])
    const [industries, setIndustries] = useState(industry)
    const [selectedLocation, setSelectedLocation]  = useState(job?.location)
    const [defaultLocation, setdefaultLocation]  = useState([{value: job?.location, label: job?.location}])
    const [locationOptions, setLocationOptions] = useState([])
    const expiryDate = moment(job?.expiry_date).format('YYYY-MM-DD')
    const beforeExpiryDate = moment(job?.expiry_date).subtract(7, 'day').format('YYYY-MM-DD')
    const currentDate = moment(new Date()).format('YYYY-MM-DD')
    const [descriptionAdd,setDescriptionAdd] = useState(job?.description)
    const [errorDescription,setErrorDescription] = useState()
    
    const experienceYearsData = [
        {display:'<1 Year', value:'0'},
        {display:'1-2 Year', value:'1'},
        {display:'2-5 Year', value:'2'},
        {display:'5-10 Year', value:'3'},
        {display:'10+ Year', value:'4'},]

    const { 
        organization_id, 
        name,
        location, 
        description, 
        skills,
        nice_to_have_skills,
        notificationemails,
        referral_amount,
        keywords,
        nice_to_have_keywords,
        department,
        experience_years,
        prefered_titles,
        prefered_industries,
        school_names,
        company_names,
        location_names,
        status } = job

    let initialState = {
        ...initialState,
        ...{
            job,
            organization_id,
            name,
            location,
            description,
            skills,
            nice_to_have_skills,
            notificationemails,
            referral_amount,
            keywords,
            nice_to_have_keywords,
            department,
            experience_years,
            prefered_titles,
            prefered_industries,
            school_names,
            company_names,
            location_names,
            status
        }
    }
    let job_description = job?.description;
    const [state, dispatch] = useReducer(reducer, initialState)
    const loadOptions = (inputValue, callback) => {
        setLoading(true)
        fetch(`/admin/organizations/get_organization?search=${inputValue}`)
        .then((res) => res.json())
        .then((res) => {
          let {organizations} = res
          setLoading(false)
          setOptions([...organizations.map((organization) => ({ value: organization.id, label: organization.name }))]);
        })
        .catch((err) => console.log("Request failed", err));
        callback(member_options);
    }

    useEffect(() => {
        const url1 = `/filter_candidate_on_location`
        const formData = new FormData()
        formData.append('filter_word', '')
        makeRequest(url1, 'post', formData, {
            contentType: 'multipart/form-data',
            loadingMessage: 'Submitting...',
            createResponseMessage: (response) => {
                setLocationOptions([...response.filter.map((res) => ({ value: res.city+ ', ' + res.state+ ' ('+res.country+')', label: res.city+ ', ' + res.state+ ' ('+res.country.toUpperCase()+')' }))]);
            },
        })

       

      }, []);

    const handleInputChange = (str) => {
        setInputValue(str)
        return str;
    }
    const locationChange = (str) => {
        setSelectedLocation(str.label)
    }
    const handleSelectOption = (selectedOptions) => {
      setSelectedOrganization([selectedOptions])
    }
    
    const saveJob = async (newJob) => {
      if(method === 'put'){
          dispatch({ type: 'update_job', value: newJob, id:job.id })
      }else{
          dispatch({ type: 'add_job', value: newJob })
      }
       
    }

    const filterOptions = [
        { value: 'active', label: 'Active' },
        { value: 'expired', label: 'Expired' },
    ]
    const colourStyles = {
        control: styles => ({ ...styles, backgroundColor: '#f5f7ff',border: 'none',height:'40px',zIndex: '15' })
    };

    const exdendExpiredJob = async () => {
        const formData = new FormData()
        for (const key in job) {
            if(key != 'status'){
                formData.append(`job[${key}]`, job[key])
            }else{
                formData.append(`job[${key}]`, 'active')
            }
        }
        const url = `/admin/exdend_job/${job.id}`
        await makeRequest(url, 'put', formData,  {
            createSuccessMessage:   () => 'Job exdend successfully ',
            onSuccess: () => {
                window.location.href = '/admin/jobs'
            },
        })
    }


    const handleEditorChange = (e) => {
        e ? setErrorDescription('') : setErrorDescription('Job description is required')
       job_description = e
    }

    return (
        <JobStoreContext.Provider value={{ state, dispatch }}>
    <div className="d-flex flex-column align-items-center justify-content-center mx-5 my-5">
    <H1>{method == 'post' ? 'Create Job' : 'Update Job'}</H1>
    <Formik
        initialValues={{
            name: job?.name,
            location: job?.location,
            description: descriptionAdd,
            skills: job?.skills,
            nice_to_have_skills: job?.nice_to_have_skills,
            notificationemails: job?.notificationemails,
            referral_amount: job?.referral_amount,
            keywords: job?.keywords,
            nice_to_have_keywords: job?.nice_to_have_keywords,
            department: job?.department,
            experience_years: job?.experience_years,
            prefered_titles: job?.prefered_titles,
            prefered_industries: job?.prefered_industries,
            school_names: job?.school_names,
            company_names: job?.company_names,
            location_names: job?.location_preference,
            status: job?.status,
        }}
        validationSchema={Yup.object({
            name: Yup.string()
                .required('Position Title is required'),
            skills: Yup.string()
                .required('Must have skills is required'),
            nice_to_have_skills: Yup.string()
                .required('Nice to have skills is required'),
            notificationemails: Yup.string()
                .required('Email is required')
                .email('Please enter valid email id'),
            department: Yup.string()
                .required('Job Department is required'),
        })}
        onSubmit={(values) => {
         
            if(job_description == '' || job_description === null || job_description === 'null'){
                setErrorDescription('Job Description is required')
                return false;
            }
            setDescriptionAdd(job_description)
            
            saveJob({
                organization_id: selectedOrganization[0].value,
                name: values.name,
                location: selectedLocation,
                description: job_description,
                skills: values.skills,
                nice_to_have_skills: values.nice_to_have_skills,
                notificationemails: values.notificationemails,
                referral_amount: values.referral_amount,
                keywords: values.keywords,
                nice_to_have_keywords: values.nice_to_have_keywords,
                department: values.department,
                experience_years: values.experience_years,
                prefered_titles: values.prefered_titles,
                prefered_industries: values.prefered_industries,
                school_names: (values.school_names == 'Specify') ? '' : values.school_names,
                company_names: (values.company_names == 'Specify') ? '' : values.company_names,
                location_names: (values.location_names == 'Specify' ) ? '' : values.location_names,
                location_preference: (values.location_names == 'Specify' ) ? '' : values.location_names,
                status: values.status,
                // company_preference: (values.company_names == 'Specify') ? '' : values.company_names,
                // education_preference: (values.school_names == 'Specify') ? '' : values.school_names
            })
        }}
    >
        <StyledForm>
            <Row>
                <Col xs={12} sm={12} lg={12}>
                  <Row>
                    <Col xs={12} sm={12} lg={4}>
                        <Label>
                            {'Select Organization*'}
                        </Label>
                        <AsyncSelect
                            isLoading={isLoading}
                            isClearable={false}
                            isDisabled={(method == 'put') ? true : false}
                            cacheOptions
                            loadOptions={loadOptions}
                            defaultValue={selectedOrganization[0]}
                            onInputChange={handleInputChange}
                            onChange={handleSelectOption}
                            styles={colourStyles}
                            placeholder= 'search for organization'
                            noOptionsMessage={() => 'start typing the name of organization'}
                        />
                    </Col>
                    <Col xs={12} sm={12} lg={4}>
                      <TextInput
                          label="Position Title*"   
                          name="name"
                          type="text"
                          id="name"
                          width="100%"
                          placeholder= 'Job title'
                      />
                    </Col>
                    <Col xs={12} sm={12} lg={4}>
                        <Label>
                            {'Location'}
                        </Label>
                        <CreatableSelect
                            isClearable
                            onChange={locationChange}
                            options={locationOptions}
                            styles={colourStyles}
                            defaultValue={defaultLocation}
                        />
                    </Col>
                  </Row>
                   
                    <Label>
                            {'Job Description*'}
                     </Label>
                    <Editor
                        initialValue={job?.description ? job.description : descriptionAdd}
                        init={{
                        toolbar: 'undo redo | bold italic | alignleft aligncenter alignright | code'
                        }}
                        onEditorChange={(newText) => handleEditorChange(newText)}
                    />
                    <Label style={{fontSize: '10px',color: 'red',marginTop: '5px'}}>
                            {errorDescription && errorDescription}        
                    </Label>
                    <br/>

                    <TextInput
                        label="Must have skills (Comma separated values e.g. PHP,MySql)*"
                        name="skills"
                        type="textarea"
                        id="skills"
                        width="100%"
                        rows="7"
                        maxLength="500"
                        placeholder= 'Must have skills'
                    />
                    <TextInput
                        label="Nice to have skills (Comma separated values e.g. PHP,MySql)*"
                        name="nice_to_have_skills"
                        type="textarea"
                        id="nice_to_have_skills"
                        width="100%"
                        rows="7"
                        maxLength="500"
                        placeholder= 'Nice to have skills'
                    />
                </Col>
                <Col xs={12} sm={12} lg={12}>
                  <Row>
                    <Col xs={12} sm={12} lg={4}>
                      <TextInput
                          label="Which Emails should the notifications for this job to sent to?*"
                          name="notificationemails"
                          type="email"
                          id="notificationemails"
                          width="100%"
                          placeholder= 'Email address'
                      />
                    </Col>
                    <Col xs={12} sm={12} lg={4}>
                      <Select
                          label="Job Department*"
                          name="department"
                          id="department"
                          width="100%"
                          type="text"
                      >
                        <option value="">Select</option>
                        <option value="Accounting">Accounting</option>
                        <option value="Finance">Finance</option>
                        <option value="Sales">Sales</option>
                        <option value="Research and Development">Research and Development </option>
                        <option value="IT">IT</option>
                        <option value="Management">Management</option>
                        <option value="Administration">Administration</option>
                        <option value="Customer support">Customer support</option>
                        <option value="Technical support">Technical support</option>
                        <option value="Marketing">Marketing</option>
                        <option value="Logistics">Logistics</option>
                        <option value="Operations">Operations</option>
                        <option value="Planning">Planning</option>
                        <option value="Human resources">Human resources</option>
                        <option value="Purchasing">Purchasing</option>
                        <option value="Quality assurance">Quality assurance</option>
                        <option value="Engineering">Engineering</option>
                        <option value="Public relations">Public relations</option>
                      </Select>
                    </Col>
                    <Col xs={12} sm={12} lg={4}>
                        <TextInput
                            label="what is the commision for the sucessful hire of a referred candidate?"
                            name="referral_amount"
                            type="text"
                            id="money"
                            width="100%"
                            placeholder="$"
                        />
                      </Col>
                  </Row>
                </Col>
                    
                <Col xs={12} sm={12} lg={12}>
                    <TextInput
                        label="Must have keyword"
                        name="keywords"
                        type="textarea"
                        id="keywords"
                        width="100%"
                        rows="7"
                        maxLength="500"
                        placeholder= 'Must have keyword'
                    />
                    <TextInput
                        label="Nice to have keywords    "
                        name="nice_to_have_keywords"
                        type="textarea"
                        id="nice_to_have_keywords"
                        width="100%"
                        rows="7"
                        maxLength="500"
                        placeholder= 'Nice to have keywords'
                    />
                </Col>
                <Col xs={12} sm={12} lg={12}>
                    <TextInput
                        label="Preferred Titles"
                        name="prefered_titles"
                        type="textarea"
                        id="prefered_titles"
                        width="100%"
                        rows="7"
                        maxLength="500"
                        placeholder= 'Preferred Titles'
                    />
                </Col>
                <Col xs={12} sm={12} lg={12}>
                    <Row>
                      <Col xs={12} sm={12} lg={4}>
                          <RedioInput
                            label="Education preferences"
                            value="Top 25 universities"
                            name="school_names"
                            type="radio"
                            id="school_names1"
                        />
                        <RedioInput
                            label="no-label"
                            value="Top 100 universitie"
                            name="school_names"
                            type="radio"
                            id="school_names2"
                        />
                        <RedioInput
                            label="no-label"
                            value="No preference"
                            name="school_names"
                            type="radio"
                            id="school_names3"
                        />
                        
                      </Col>
                      <Col xs={12} sm={12} lg={4}>
                          <RedioInput
                            label="Company preferences"
                            value="Industry leaders"
                            name="company_names"
                            type="radio"
                            id="company_names1"
                        />
                        <RedioInput
                            label="no-label"
                            value="Fortune 500"
                            name="company_names"
                            type="radio"
                            id="company_names2"
                        />
                        <RedioInput
                            label="no-label"
                            value="Start-ups"
                            name="company_names"
                            type="radio"
                            id="company_names3"
                        />
                        <RedioInput
                            label="no-label"
                            value="No preference"
                            name="company_names"
                            type="radio"
                            id="company_names4"
                        />
                      
                      </Col>
                      <Col xs={12} sm={12} lg={4}>
                          <RedioInput
                            label="Location prefrence"
                            value="Anywhere in US"
                            name="location_names"
                            type="radio"
                            id="location_names1"
                        />
                       
                      </Col>
                    </Row>  
                </Col>
                <Col xs={12} sm={12} lg={12}>
                  <Row>
                    <Col xs={12} sm={12} lg={4}>
                      <Select
                          label="Experience"
                          name="experience_years"
                          id="experience_years"
                          width="100%"
                          type="text"
                      >
                        {experienceYearsData && experienceYearsData.map((a, index) => {
                            return (
                                <option key={a.value} value={a.value}>{a.display}</option>
                            )
                        })}
                      </Select>
                    </Col>
                    <Col xs={12} sm={12} lg={4}>
                        <Select
                            label="Preferred Industries"
                            name="prefered_industries"
                            id="prefered_industries"
                            width="100%"
                            type="text"
                        >
                            <option value="">Select</option>
                            { industries.map(({ key, value }) => {
                                return (
                                <option value={key} key={key}>{value}</option>
                                )
                            })}
                        </Select>
                        
                       
                      </Col>
                      <Col xs={12} sm={12} lg={4}>
                      {job && (
                        <TextInput
                            label="Status*"
                            name="status"
                            type="text"
                            id="status"
                            width="100%"
                            as="select"
                        >   
                            <option value="active">Active</option>
                            <option value="pending">Pending</option>
                            <option value="expired">Expired</option>
                            <option value="block">Blocked</option>
                        </TextInput>
                        )}
                    </Col>
                  </Row>
                </Col>
                
            </Row>
            <Row>
                <Col>
                    <div style={{ marginTop: '18px' }}>
                        <Button type="submit">Save</Button>
                        <Button
                            type="button"
                            onClick={() => window.history.back()}
                            className="ml-sm-3"
                        >   
                            Go Back
                        </Button>
                        {job && expiryDate >= beforeExpiryDate && beforeExpiryDate <= currentDate && expiryDate >= currentDate  && (
                        <Button
                            type="button"
                            onClick={exdendExpiredJob}
                            className="ml-sm-3"
                        >   
                            Extend Expired Job
                        </Button>)
    
                        }
                        
                    </div>
                </Col>
            </Row>
        </StyledForm>
    </Formik>
  </div>
  </JobStoreContext.Provider>
  )
}
export default JobsCreate