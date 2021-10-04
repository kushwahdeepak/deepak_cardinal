import React, { useEffect, useReducer, useRef, useState } from 'react'
import { Formik } from 'formik'
import * as Yup from 'yup'
import Resizer from 'react-image-file-resizer'
import { Row, Col } from 'react-bootstrap'
import stateCities from 'state-cities'
import AsyncSelect from "react-select/async";
import Card from './shared/Card'
import Table from './shared/Table'
import TableWrapper from './shared/TableWrapper'
import P from './shared/P'
import { H1, StyledForm } from './styles/UserManagementEditPage.styled'
import TextInput from './shared/TextInput'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import {
    Logo,
    Button,
    Member,
    RemoveButton,
    MemberButton,
} from './styles/OrganizationManagementEditPage.styled'
import { reducer, OrganizationContext } from '../../../stores/Admin/OrganizationStore' 
import moment from 'moment'

const redirectToOrganizationsManagement = () => {
   window.location.href = '/admin/organizations_management'
}
const capitalize = (s) => {
    if (typeof s !== 'string') return ''
    return s.charAt(0).toUpperCase() + s.slice(1)
}

const OrganizationManagementEditPage = ({
    organization,
    contact,
    members,
    avatar_url,
    jobs
}) => {
    const [compnanySizes, setCompnanySizes] = useState([])
    const [industries, setIndustries] = useState([])
    const [logo, setLogo] = useState(avatar_url)
    const [logoError, setLogoError] = useState(null)
    const [stateError, setStateError] = useState(null)
    const [cityError, setCityError] = useState(null)
    const [logoUrl, setLogoUrl] = useState(logo ? logo : null)
    const inputRef = useRef()
    const [recruiterEmail, setRecruiterEmail] = useState()
    const [states, setStates] = useState(stateCities.getStates())
    const [selectState, setSelectState] = useState(organization.region)
    const [citys, setCitys] = useState(null)
    const [selectCity, setSelectCity] = useState(organization.city)
    const [tags, setTags] = useState([]);
    const [suggestions,setSuggestions] = useState([]);
    const [member_options, setOptions] = useState([])
    const [inputValue, setInputValue] = useState('')
    const [isLoading, setLoading] = useState(false)
    const [selectedMemberList, setMembersList]  = useState([])
    const { name,industry,company_size,description,country,region,city,status } = organization
    let initialState = {
        ...initialState,
        ...{
            organization,
            name,
            industry,
            company_size,
            description,
            country,
            region,
            city,
            status,
            logo
        }
    }
    const [state, dispatch] = useReducer(reducer, initialState)
    useEffect(() => {
        const lookupsUrl = '/signup/lookups'
        makeRequest(lookupsUrl, 'get', '').then((res) => {
            setCompnanySizes([...res.data.company_sizes])
            setIndustries([...res.data.industries])
        })
        setStates(stateCities.getStates())
        
    }, [])
    useEffect(() => {
        setCitys(stateCities.getCities(selectState))
    },[organization.region,states])
    
    const saveOrganization = async (newOrg) => {
        dispatch({ type: 'save-organization', value: newOrg,id:organization.id })
    }

    const resizeFile = (file) =>
        new Promise((resolve) => {
            Resizer.imageFileResizer(
                file,
                150,
                150,
                'PNG',
                100,
                0,
                (uri) => {
                    resolve(uri)
                },
                'file',
                150,
                150
            )
    })

    const onSelectState = (event) => {
        setSelectState(event.target.value)
        setCitys(stateCities.getCities(event.target.value))
    }

    const onSelectCity = (event) => {
        setSelectCity(event.target.value)
    }

    const addLogo = async (e) => {
        e.persist()
        const compressedImage = await resizeFile(e.target.files[0])
        setLogoError(null)
        setLogo(compressedImage)
        setLogoUrl(URL.createObjectURL(compressedImage))
    }

    const approve = async () => {
        dispatch({ type: 'approve-organization',id:organization.id })
    }
    const reject = async () => {
        dispatch({ type: 'reject-organization',id:organization.id })
        redirectToOrganizationsManagement()
    }

    const handleInputChange = (str) => {
      setInputValue(str)
      return str;
    }

    const handleSelectOption = (selectedOptions) => {
      console.table(selectedOptions)
      setMembersList([...selectedOptions.map( ({value, label}) =>({user_id: value, organization_id: organization.id}) )])
    }

    const loadOptions = (inputValue, callback) => {
      console.log('loading....')
      setLoading(true)
      fetch(`/admin/recruiters/get_recruiter_users.json?search=${inputValue}`)
      .then((res) => res.json())
      .then((res) => {
        let {users} = res
        setLoading(false)
        setOptions([...users.map((user) => ({ value: user.id, label: user.email }))]);
      })
      .catch((err) => console.log("Request failed", err));

      callback(member_options);
    }

    const addRecruiter = async (event) => {
        event.preventDefault()
        dispatch({ type: 'add-recruiter',value:selectedMemberList, id:organization.id })
    }

    const removeOrganizationRecruiter = async (event, recruiter_org_id) => {
        event.preventDefault()
        dispatch({ type: 'remove-recruiter-organization', id:recruiter_org_id })
    }

    return (
        <OrganizationContext.Provider value={ state, dispatch }>
        <div className="d-flex flex-column align-items-center justify-content-center mx-5 my-5">
            <H1>Update organization</H1>
            <Formik
                initialValues={{
                    name: organization.name || '',
                    email: contact || '',
                    industry: organization.industry || '',
                    companySize: organization.company_size || '',
                    description: organization.description || '',
                    logo: logo,
                    status: organization.status,
                    country: 'USA',
                    city: organization.city,
                    region: organization.region,
                }}
                validationSchema={Yup.object({
                    name: Yup.string().required(
                        'Organization Name is required'
                    ),
                    country: Yup.string().required('Country Email is required'),
                    // region: Yup.string().required('Region Email is required'),
                    // city: Yup.string().required('City Email is required'),
                    email: Yup.string().required(
                        'Organization Email is required'
                    ),
                    industry: Yup.string()
                        .required('Industry is required')
                        .oneOf(
                            industries.map(({ key, value }) => key),
                            'Invalid Industry'
                        ),
                    companySize: Yup.string()
                        .required('Company size is required')
                        .oneOf(
                            compnanySizes.map(({ key, value }) => key),
                            'Invalid Company Size'
                        ),
                    description: Yup.string().required(
                        'Description is required'
                    ),
                })}
                validate={(values) => {
                    const errors = {}
                    if (typeof logo !== 'string') {
                        if (!logo) {
                            errors.logo = 'Logo is required'
                        } else if (
                            ![
                                'image/jpg',
                                'image/jpeg',
                                'image/gif',
                                'image/png',
                            ].includes(logo.type)
                        ) {
                            errors.logo =
                                'Logo can only ne of type jpg, png, gif, jpeg'
                        }
                    }
                    setLogoError(errors.logo)
                    setCityError(errors.city)
                    return errors
                }}
                onSubmit={(values) => {
                    saveOrganization({
                        name: values.name,
                        industry: values.industry,
                        company_size: values.companySize,
                        description: values.description,
                        country: values.country,
                        region: selectState,
                        city: selectCity,
                        status: values.status,
                        logo: logo,
                    })
                }}
            >
                <StyledForm>
                    <Row>
                        <Col xs={12} sm={12} lg={8}>
                            <H1>Organization Details</H1>
                            <Row>
                                <Col xs={12} sm={12} lg={3}>
                                    <div style={{ display: 'grid' }}>
                                        <Logo image={logoUrl}>
                                            {logoUrl
                                                ? ''
                                                : 'Upload Company Logo'}
                                        </Logo>

                                        {logoError && (
                                            <span
                                                style={{
                                                    fontSize: '10px',
                                                    color: 'red',
                                                    marginTop: '5px',
                                                }}
                                            >
                                                {logoError}
                                            </span>
                                        )}
                                        <input
                                            type="file"
                                            name="logo"
                                            id="logo"
                                            ref={inputRef}
                                            hidden
                                            onChange={addLogo}
                                        />

                                        <Button
                                            style={{
                                                marginTop: '15px',
                                                maxWidth: '150px',
                                                marginBottom: '20px',
                                            }}
                                            type="button"
                                            onClick={() =>
                                                inputRef.current.click()
                                            }
                                        >
                                            Upload File
                                        </Button>
                                    </div>
                                </Col>
                                <Col xs={12} sm={12} lg={9}>
                                    <TextInput
                                        label="Organization Name*"
                                        name="name"
                                        type="text"
                                        id="name"
                                        width="100%"
                                    />
                                    <Row>
                                        <Col xs={12} sm={12} lg={6}>
                                            <TextInput
                                                as="select"
                                                label="Industry*"
                                                name="industry"
                                                type="text"
                                                id="industry"
                                                width="100%"
                                            >
                                                <option value="">Select</option>
                                                {industries.map(
                                                    ({ key, value }) => {
                                                        return (
                                                            <option
                                                                key={key}
                                                                value={key}
                                                            >
                                                                {value}
                                                            </option>
                                                        )
                                                    }
                                                )}
                                            </TextInput>
                                        </Col>
                                        <Col xs={12} sm={12} lg={6}>
                                            <TextInput
                                                as="select"
                                                label="Company Size*"
                                                name="companySize"
                                                type="text"
                                                id="companySize"
                                                width="100%"
                                            >
                                                <option value="">Select</option>
                                                {compnanySizes.map(
                                                    ({ key, value }) => {
                                                        return (
                                                            <option
                                                                key={key}
                                                                value={key}
                                                            >
                                                                {value}
                                                            </option>
                                                        )
                                                    }
                                                )}
                                            </TextInput>
                                        </Col>
                                    </Row>
                                </Col>
                            </Row>
                            <Row>
                                <Col xs={4} sm={4} lg={4}>
                                    <TextInput
                                        label="Country*"
                                        name="country"
                                        type="text"
                                        id="country"
                                        style={{ width: 'auto' }}
                                    />
                                </Col>
                                <Col xs={4} sm={4} lg={4}>
                                    <TextInput
                                        as="select"
                                        label="State"
                                        name="region"
                                        type="text"
                                        id="region"
                                        style={{ width: 'auto' }}
                                        value={selectState}
                                        onChange={onSelectState}
                                    >
                                        {onSelectState}
                                        <option value="">Select</option>
                                        {states &&
                                            states.map((value,index) => {
                                                if(!(value === "American Samoa" || value === "Guam" || value === "Howland Island" || value === "Baker Island" || value === "Jarvis Island" || value === "Johnston Atoll" || value === "Kingman Reef" || value === "Navassa Island" || value === "Palmyra Atoll" || value === "Wake Island"))
                                                {
                                                    return (
                                                        <option
                                                            key={index}
                                                            data-code={
                                                                value
                                                            }
                                                            value={value}
                                                        >
                                                            {value}
                                                        </option>
                                                    )
                                                }
                                            })}
                                    </TextInput>
                                </Col>
                                <Col xs={4} sm={4} lg={4}>
                                    <TextInput
                                        as="select"
                                        label="City"
                                        name="city"
                                        type="text"
                                        id="city"
                                        style={{ width: 'auto' }}
                                        value={selectCity}
                                        onChange={onSelectCity}
                                    >
                                        <option value="">Select</option>
                                        {citys &&
                                            citys.map((value,index) => {
                                                return (
                                                    <option
                                                        key={index}
                                                        code={value}
                                                        value={value}
                                                    >
                                                        {value}
                                                    </option>
                                                )
                                            })}
                                    </TextInput>
                                </Col>
                            </Row>
                            <TextInput
                                label="Description*"
                                name="description"
                                type="text"
                                id="description"
                                width="100%"
                            />
                            <TextInput
                                label="Status*"
                                name="status"
                                type="text"
                                id="status"
                                width="100%"
                                as="select"
                            >   
                               {organization.status === 'pending' && (
                                  <option value="pending">Pending</option>
                               )}
                                <option value="approved">Approved</option>
                                <option value="declined">Rejected</option>
                            </TextInput>
                        </Col>
                        <Col xs={12} sm={12} lg={4}>
                            <H1>Contact person</H1>
                            <TextInput
                                label="Organization Manager*"
                                name="email"
                                type="email"
                                id="email"
                                width="100%"
                            />

                            {organization.status === 'pending' && (
                                <div>
                                    <H1>Pending organization request</H1>
                                    <Button
                                        type="button"
                                        onClick={approve}
                                        className="ml-sm-3"
                                        variant="success"
                                    >
                                        Approve
                                    </Button>
                                    <Button
                                        type="button"
                                        onClick={reject}
                                        variant="danger"
                                        className="ml-sm-3"
                                    >
                                        Reject
                                    </Button>
                                </div>
                            )}
                            <hr></hr>
                            <H1>Members</H1>
                            <Row className="mb-4">
                                <Col xs={12} sm={12} lg={8}>
                                <AsyncSelect
                                  isMulti
                                  isLoading={isLoading}
                                  isClearable={true}
                                  cacheOptions
                                  loadOptions={loadOptions}
                                  defaultOptions
                                  onInputChange={handleInputChange}
                                  onChange={handleSelectOption}
                                  placeholder={'search for recruiter'}
                                />
                                   
                                </Col>
                                <Col xs={12} sm={12} lg={4} className="text-center">
                                    <Button
                                        className=""
                                        onClick={(e) =>addRecruiter(e)}
                                    >
                                        Add
                                    </Button>
                                </Col>
                            </Row>
                            {members && 
                                members.map((member, key) => {
                                return (
                                    <Member key={key}>
                                        <Row>
                                            <Col xs={12} sm={12} lg={8}>
                                                <h5>
                                                    {capitalize(
                                                        member.first_name
                                                    )}{' '}
                                                    {capitalize(
                                                        member.last_name
                                                    )}
                                                </h5>
                                                <h6>{member.email}</h6>
                                            </Col>
                                            <Col xs={12} sm={12} lg={4}>
                                                <MemberButton>
                                                    <RemoveButton
                                                        onClick={(event) =>
                                                            removeOrganizationRecruiter(
                                                                event,
                                                                member.id
                                                            )
                                                        }
                                                    >
                                                        Remove
                                                    </RemoveButton>
                                                </MemberButton>
                                            </Col>
                                        </Row>
                                    </Member>
                                )
                            })}
                        </Col>
                    </Row>
                    <Row>
                        <Col>
                            <div style={{ marginTop: '18px' }}>
                                <Button type="submit">Update</Button>
                                <Button
                                    type="button"
                                    onClick={() => window.history.back()}
                                    className="ml-sm-3"
                                >
                                    Go Back
                                </Button>
                            </div>
                        </Col>
                    </Row>
                </StyledForm>
            </Formik>
        </div>
        <div className="d-flex flex-column align-items-center justify-content-center mx-5 my-5">
            <H1>Organization Jobs</H1>
            <TableWrapper>
                {jobs && jobs?.length > 0 ? (
                    <Table
                    columNames={[
                        {
                            name: 'No.',
                            field: 'id',
                            editable: false,
                            type: 'text',
                        },
                        {
                            name: 'Job Name',
                            field: 'name',
                            editable: true,
                            type: 'text',
                        },{
                            name: 'Location',
                            field: 'location',
                            editable: false,
                            type: 'text',
                        },
                        {
                            name: 'Skills',
                            field: 'nice_to_have_skills',
                            editable: false,
                            type: 'text',
                        },
                        {
                            name: 'Created On',
                            field: 'created_at',
                            editable: false,
                            type: 'text',
                        },
                        {
                            name: 'Status',
                            field: 'status',
                            editable: false,
                            type: 'text',
                        },
                    ]}
                    rowValues={jobs.map((o) => ({
                        ...o,
                        created_at: moment(o.created_at).format('DD MMMM YYYY'),
                        image_url: <img src={o.image_url} style={{height: '70px', width: '80px',borderRadius:'10px',marginLeft:'18px'}}/>,
                        status : capitalize(o.status)
                    }))}
                    activePage={0}
                    goToEditPage={(id) =>
                        (window.location.href = `/admin/jobs/${id}/edit`)
                    }
                />
                ): 'This Organization has no jobs.'}
            </TableWrapper>
        </div>
        </OrganizationContext.Provider>
    )
}

export default OrganizationManagementEditPage