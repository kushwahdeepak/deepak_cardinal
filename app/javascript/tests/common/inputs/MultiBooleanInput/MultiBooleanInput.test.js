import React from 'react';
import MultiBooleanInput from '../../../../components/common/inputs/MultiBooleanInput/MultiBooleanInput';
import renderer from 'react-test-renderer';
import { configure, shallow, mount } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import { findByTestAttr } from '../../../../utils';

configure({adapter: new Adapter()});

const initialShallowRender = (props = {}) => {
	return shallow(<MultiBooleanInput {...props}/>);
};

const initialMountRender = (props = {}) => {
	return mount(<MultiBooleanInput {...props}/>);
};


describe('MultiBooleanInput component',  () => {
	let wrapper;
	let fullWrapper;

	beforeEach(() => {

		const props = {
		};
		wrapper = initialShallowRender(props);
		fullWrapper = initialMountRender(props);
	});

	afterEach(() => {
		fullWrapper.unmount();
	});

	it('should render MultiBooleanInput component', () => {
		expect(wrapper.exists()).toBe(true);
	});

	it('should match with a snapshot', () => {
		const component = renderer.create(<MultiBooleanInput />);
		let tree = component.toJSON();
		expect(tree).toMatchSnapshot();
	});

	describe('MultiBooleanInput component with props', () => {

	});
	describe('MultiBooleanInput component without props', () => {

	});
});
