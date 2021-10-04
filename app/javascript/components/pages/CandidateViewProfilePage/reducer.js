export const reducer = (state, action) => {
    switch (action.type) {
        case 'firstName':
            return { ...state, firstName: action.value }
        case 'lastName':
            return { ...state, lastName: action.value }
        case 'employer':
            return { ...state, employer: action.value }
        case 'title':
            return { ...state, title: action.value }
        case 'skills': {
            let skillsArray
            if (state.skills.length > 0) skillsArray = state.skills.split(',')
            else skillsArray = []
            skillsArray.push(action.value)
            let skillString = skillsArray.toString()
            return { ...state, skills: skillString }
        }
        case 'education':
            return { ...state, education: action.value }
        case 'location':
            return { ...state, location: action.value }
        case 'profilePictureName':
            return { ...state, profilePictureName: action.value }
        case 'profilePicture':
            return { ...state, profilePicture: action.value }
        case 'description':
            return { ...state, description: action.value }
        case 'experiences': {
            let value = action.value.value
            let name = action.value.name
            let oldExperiences = state.experiences
            let experience = oldExperiences[action.index]
            let newExperience = { ...experience, [name]: value }
            oldExperiences[action.index] = newExperience
            return { ...state, experiences: [...oldExperiences] }
        }

        case 'newExperience': {
            return {
                ...state,
                experiences: [...state.experiences, action.value],
            }
        }

        case 'experienceStartDate': {
            let oldExperiences = state.experiences
            let experience = oldExperiences[action.index]
            let updateExperience = { ...experience, start_date: action.value }
            oldExperiences[action.index] = updateExperience
            return { ...state, experiences: oldExperiences }
        }
        case 'experienceEndDate': {
            let oldExperiences = state.experiences
            let experience = oldExperiences[action.index]
            let updateExperience = { ...experience, end_date: action.value }
            oldExperiences[action.index] = updateExperience
            return { ...state, experiences: oldExperiences }
        }

        case 'removeskill': {
            let oldSkills = state.skills.split(',')
            let newSkills = oldSkills.filter(
                (_, index) => index != action.index
            )

            return { ...state, skills: newSkills.toString() }
        }

        case 'removeExperience': {
            let prevExperiences = [...state.experiences]
           
            let newExperences = prevExperiences.filter(
                (_, index) => index != action.index
            )
            state.deleteExperienceId.push(action.id)
            return { ...state, experiences: newExperences }
        }

        default:
            return { ...state }
    }
}
