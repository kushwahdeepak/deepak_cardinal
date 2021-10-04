import React from 'react';
import FilterStack from '../../../components/common/FilterStack/FilterStack';
import renderer from 'react-test-renderer';
import { configure, shallow, mount } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import { findByTestAttr } from '../../../utils';

configure({adapter: new Adapter()});

const initialShallowRender = (props = {}) => {
	return shallow(<FilterStack {...props}/>);
};

const initialMountRender = (props = {}) => {
	return mount(<FilterStack {...props}/>);
};

window.ch_const = {};
const initialProps = {
	filterStack: {},
	setStackFilter: jest.fn()
};


describe('FilterStack component',  () => {
	let wrapper;
	let fullWrapper;

	beforeEach(() => {

		const props = {
			...initialProps
		};
		wrapper = initialShallowRender(props);
		fullWrapper = initialMountRender(props);
	});

	afterEach(() => {
		fullWrapper && fullWrapper.unmount();
	});

	it('should render FilterStack component', () => {
		expect(wrapper.exists()).toBe(true);
	});

	it('should match with a snapshot', () => {
		const component = renderer.create(<FilterStack {...initialProps} />);
		let tree = component.toJSON();
		expect(tree).toMatchSnapshot();
	});

	describe('FilterStack component with props', () => {

	});
	describe('FilterStack component without props', () => {

	});
});
