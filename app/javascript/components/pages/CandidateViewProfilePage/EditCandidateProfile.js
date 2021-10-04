import React, {
    useContext,
    useState,
    Fragment,
    useEffect,
    useRef,
} from 'react'
import feather from 'feather-icons'
import validator from 'validator'
import CandidateTwoImage from '../../../../assets/images/img_avatar.png'
import CloseButton from '../../common/Styled components/CloseButton'
import Input from '../../common/Styled components/Input'
import EditExperience from './EditExperience'
import ProfileUploader from '../CandidateProfilePage/ProfileUploader'
import Alert from 'react-bootstrap/Alert'
import {
    Wrapper,
    Row,
    Container,
    InputContainer,
    Button,
    Button2,
    ImageContainer,
    Skill,
    W4text,
    W8text,
    W5text,
    ScrollContainer,
} from './styles/CandidateViewProfile.styled'
import { UserProfileContext } from '../../../stores/UserProfileStore'
import Modal from '../../common/Styled components/Modal'
import CropImageModal from './CropImageModal'

function EditCandidateProfile(props) {
    const { open, setOpen, format_logo_url } = props
    const [openInner, setOpenInner] = useState(false)
    const [isAddSkill, setIsAddSkill] = useState(false)
    const [isSubmit, setIsSubmit] = useState(false)
    const { state, dispatch } = useContext(UserProfileContext)
    const [initialState, setState] = useState({ ...state })
    const [profile, setProfile] = useState()
    const {
        currentUser,
        person,
        first_name,
        last_name,
        description,
        experiences,
        skills,
        title,
        employer,
        school,
        location,
        avatar_url,
        deleteExperienceId,
        skillset,
    } = initialState
    const [validationErrors, setValidationErrors] = useState([])

    useEffect(() => {
        feather.replace()
    })

    const data = [
        { type: 'first_name', label: 'First Name', value: first_name },
        { type: 'last_name', label: 'Last Name', value: last_name },
        { type: 'title', label: 'Current Position', value: title },
        { type: 'employer', label: 'Company', value: employer },
        { type: 'location', label: 'Location', value: location },
        { type: 'school', label: 'Education', value: school },
    ]

    const handleAddSkill = () => {
        setIsAddSkill(!isAddSkill)
        if (isAddSkill && skillset.trim() !== '') {
            setState({
                ...initialState,
                skills: [...skills, skillset],
                skillset: '',
            })
        }
    }

    const removeSkill = (item) => {
        const skillArr = skills.filter((skill) => skill != item)
        setState({ ...initialState, skills: [...skillArr] })
    }

    const handleOnSave = async () => {
        setIsSubmit(true)
        const valid = !!(
            first_name.length &&
            validator.trim(first_name) &&
            last_name.length &&
            validator.trim(last_name)
        )
        let isvalidExperience = true

        if (experiences && experiences.length > 0) {
            experiences.forEach((element) => {
                if (
                    !(
                        element.title.length &&
                        validator.trim(element.title) &&
                        element.company_name.length &&
                        validator.trim(element.company_name)
                    )
                ) {
                    isvalidExperience = false
                    return true
                }
            })
        }

        if (valid && isvalidExperience) {
            dispatch({ type: 'update_user_profile', value: initialState })
            setOpen(false)
        } else {
            setValidationMessages()
        }
    }

    const setValidationMessages = () => {
        let errors = []
        if (!(first_name.length && validator.trim(first_name)))
            errors.push('First Name is required')
        if (!(last_name.length && validator.trim(last_name)))
            errors.push('Last Name is required')

        if (experiences && experiences.length > 0) {
            experiences.forEach((element) => {
                if (!(element.title.length && element.company_name.length)) {
                    errors.push('Experience detail is required')
                    return true
                }
            })
        }

        setValidationErrors(errors)
    }

    const handlePictureError = (error) => {
        let errors = []
        errors.push(error)
        setValidationErrors(errors)
    }
    const handlePicture = (file) => {
        if (file && file.size > 1024 * 1024 * 4) {
            handlePictureError('File size cannot exceed more than 4MB')
        } else {
            let errors = []
            setValidationErrors(errors)
            setProfile(format_logo_url(file))
        }
    }
    const saveCropImage = (upImg) => {
        setState({ ...initialState, avatar_url: upImg})
        setOpenInner(!openInner)
    }

    const handelInput = (event) => {
        const { name, value } = event.target
        setValidationMessages()
        setState({ ...initialState, [name]: value })
    }
    const handleNewExperience = () => {
        const newExperience = {
            title: '',
            location: '',
            description: '',
            company_name: '',
            start_date: '',
            end_date: '',
            present: false,
        }
        setState({
            ...initialState,
            experiences: [...experiences, newExperience],
        })
    }

    const handleExperience = (event, index) => {
        const { name, value } = event.target
        const oldExperiences = experiences
        const experience = oldExperiences[index]
        const newExperience = { ...experience, [name]: value }
        oldExperiences[index] = newExperience
        setState({ ...initialState, experiences: [...oldExperiences] })
    }

    const handleExperienceDate = (date, index, type) => {
        let oldExperiences = experiences
        let experience = oldExperiences[index]
        let updateExperience = {}
        if (type === 'startDate') {
            updateExperience = { ...experience, start_date: date }
        } else {
            updateExperience = { ...experience, end_date: date }
        }

        oldExperiences[index] = updateExperience
        setState({ ...initialState, experiences: oldExperiences })
    }
    const handleRemoveExperience = (experienceId, removeIndex) => {
        let prevExperiences = [...experiences]

        let newExperences = prevExperiences.filter(
            (_, index) => index != removeIndex
        )
        deleteExperienceId.push(experienceId)
        setState({ ...initialState, experiences: newExperences })
    }

    return (
        <Wrapper>
            <Container direction="column" style={{ height: '100%' }}>
                <Row direction="row" jContent="space-between">
                    <W4text size="32px" color="#1D2447">
                        Edit Profile
                    </W4text>
                    <CloseButton handleClick={() => setOpen(!open)} />
                </Row>

                <ScrollContainer>
                    {validationErrors.length > 0 && (
                        <Alert
                            variant="danger"
                            onClose={() => setValidationErrors([])}
                            dismissible
                        >
                            {validationErrors.map((error, idx) => (
                                <p key={idx} className="mb-0">
                                    {error}
                                </p>
                            ))}
                        </Alert>
                    )}
                    <Row direction="row">
                        <Container
                            direction="column"
                            jContent="space-between"
                            flex="2"
                        >
                            <W4text
                                size="12px"
                                color="#7A8AC2"
                                style={{
                                    alignSelf: 'flex-start',
                                    marginBottom: '8px',
                                }}
                            >
                                Profile Picture
                            </W4text>
                            <ImageContainer>
                                <img
                                src={
                                    avatar_url == null || avatar_url == ''
                                        ? CandidateTwoImage
                                        : format_logo_url(avatar_url)
                                }
                            />
                                    
                            </ImageContainer>
                            <div style={{ marginLeft: '12px' }}>
                                <ProfileUploader
                                    onFileSelectSuccess={(file) =>{
                                        handlePicture(file)
                                        setOpenInner(!openInner)
                                        }
                                    }
                                    onFileSelectError={({ error }) =>
                                        handlePictureError(error)
                                    }
                                    isProfilePicture={'profilePicture'}
                                />
                                { profile && (
                                    <Modal
                                        width={'50%'}
                                        isOpen={openInner}
                                        onBlur={() => setOpenInner(!openInner)}
                                    >
                                        <CropImageModal
                                            setOpenInner={setOpenInner}
                                            profile={profile}
                                            saveCropImage={saveCropImage} 
                                            handlePicture = {(file) => {handlePicture(file)}}
                                        />
                                    </Modal>
                                )}
                            
                            </div>
                        </Container>
                        <Container
                            direction="row"
                            flex="10"
                            jContent="space-around"
                        >
                            {data.map(({ label, type, value }, index) => {
                                return (
                                    <Fragment key={index}>
                                        <InputContainer width="48%">
                                            <Input
                                                name={type}
                                                value={(value != null && value != 'null') ? value : '' }
                                                label={label}
                                                isValid={
                                                    isSubmit
                                                        ? type ===
                                                              'firstName' ||
                                                          type === 'lastName'
                                                            ? !!data[index]
                                                                  .value?.length
                                                            : true
                                                        : true
                                                }
                                                onChange={handelInput}
                                                type="text"
                                            />
                                        </InputContainer>
                                    </Fragment>
                                )
                            })}
                        </Container>
                    </Row>
                    <Row direction="row">
                        <Input
                            value={(description != null && description != 'null') ? description : ''}
                            label="About Me"
                            name="description"
                            isValid={true}
                            onChange={handelInput}
                            type="textarea"
                            maxLength="500"
                        />
                    </Row>
                    <Row direction="column">
                        <W4text
                            size="12px"
                            color="#7A8AC2"
                            style={{ marginBottom: '8px' }}
                        >
                            {isAddSkill ? 'Skills (Max. 20)' : 'Skills'}
                        </W4text>

                        <Container direction="row">
                            {skills.map((item, index) => {
                                return (
                                    <Skill key={index}>
                                        <W4text color="#768bff" size="12px">
                                            {item.trim() && item}
                                        </W4text>
                                        <span
                                            className="span"
                                            onClick={() => {
                                                removeSkill(item)
                                            }}
                                        >
                                            <i data-feather="x" />
                                        </span>
                                    </Skill>
                                )
                            })}
                            {isAddSkill && (
                                <div
                                    style={{
                                        display: 'flex',
                                        alignItems: 'center',
                                    }}
                                >
                                    <Input
                                        value={skillset}
                                        label="no-label"
                                        name="skills"
                                        onChange={(e) => {
                                            setState({
                                                ...initialState,
                                                skillset: e.target.value,
                                            })
                                        }}
                                        type="text"
                                    />
                                </div>
                            )}
                            {skills.length < 20 && (
                                <Button
                                    lr="16px"
                                    tb="11px"
                                    onClick={() => handleAddSkill()}
                                >
                                    <W5text size="12px" color="#ffff">
                                        {isAddSkill ? 'Add' : '+ Add Skill'}
                                    </W5text>
                                </Button>
                            )}
                        </Container>
                    </Row>
                    <Row direction="column">
                        <W4text size="18px" color="#283A7A">
                            Experience
                        </W4text>
                    </Row>
                    <Row direction="column">
                        {experiences?.map((experience, index) => (
                            <Fragment key={index}>
                                <EditExperience
                                    experience={experience}
                                    dispatch={dispatch}
                                    index={index}
                                    isLastIndex={
                                        state.experiences?.length - 1 === index
                                    }
                                    handleExperience={handleExperience}
                                    handleExperienceDate={handleExperienceDate}
                                    handleRemoveExperience={
                                        handleRemoveExperience
                                    }
                                />
                            </Fragment>
                        ))}
                    </Row>

                    <Row direction="row">
                        <Button2
                            lr="16px"
                            tb="5px"
                            onClick={() => handleNewExperience()}
                        >
                            <W8text size="14px" color="#7286F0">
                                Add Experience Section
                            </W8text>
                        </Button2>
                    </Row>
                </ScrollContainer>

                <Row
                    direction="row"
                    jContent="flex-end"
                    style={{ marginBottom: '0px' }}
                >
                    <Button onClick={handleOnSave} lr="16px" tb="5px">
                        <W8text size="14px" color="#ffff">
                            Save Changes
                        </W8text>
                    </Button>
                </Row>
            </Container>
        </Wrapper>
    )
}

export default EditCandidateProfile
