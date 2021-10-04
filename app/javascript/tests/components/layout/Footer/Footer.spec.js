import React from 'react'
import Footer from '../../../../components/layout/Footer/Footer'
import renderer from 'react-test-renderer'
import { configure, shallow } from 'enzyme'
import Adapter from 'enzyme-adapter-react-16'
import { findByTestAttr } from '../../../../utils/index'

configure({ adapter: new Adapter() })

describe('Footer component', function () {
    let wrapper
    beforeEach(() => {
        wrapper = shallow(<Footer />)
    })

    it('should render Footer component', () => {
        expect(wrapper.exists()).toBe(true)
    })
    it('should match with a snapshot', () => {
        const component = renderer.create(<Footer />)
        let tree = component.toJSON()
        expect(tree).toMatchSnapshot()
    })
    it('should contain the root footer tag', () => {
        expect(wrapper.find('footer').length).toBe(1)
    })
    it('should contain the correct number of children in the root tag', () => {
        expect(wrapper.find('footer').children().length).toBe(1)
    })
    it('should contain correct href prop for links', () => {
        expect(
            findByTestAttr(wrapper, 'report-bug-link').at(0).props().href
        ).toBe('mailto:tech-support@cardinalhire.com')
    })
})
