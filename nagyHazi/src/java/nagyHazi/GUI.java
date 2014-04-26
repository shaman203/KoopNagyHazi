package nagyHazi;


import jason.architecture.AgArch;
import jason.asSemantics.ActionExec;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.ListTerm;
import jason.asSyntax.Literal;
import jason.asSyntax.Term;

import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.List;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;


public class GUI extends AgArch {

	JTextArea jt;
	JFrame    f;
	JButton broadcastRandom;
	JButton broadcastAll;

	List<String> agentList;

	public GUI() {
		jt = new JTextArea(10, 30);
		jt.setEditable(false);
		broadcastRandom = new JButton("Add connection");
		broadcastRandom.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				
				Literal goal = ASSyntax.createLiteral("create_connection");
				goal.addTerms(ASSyntax.createString("router1"));
				goal.addTerms(ASSyntax.createString("router2"));
				goal.addTerms(ASSyntax.createNumber(5));
				getTS().getC().addAchvGoal(goal, null);


			}
		});

		broadcastAll = new JButton("Drop connection");
		broadcastAll.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				
				Literal goal = ASSyntax.createLiteral("drop_connection");
				goal.addTerms(ASSyntax.createString("router1"));
				goal.addTerms(ASSyntax.createString("router2"));
				goal.addTerms(ASSyntax.createNumber(5));
				getTS().getC().addAchvGoal(goal, null);

			}
		});

		f = new JFrame("Simulator");
		f.getContentPane().setLayout(new BorderLayout());
		f.getContentPane().add(BorderLayout.NORTH, new JScrollPane(jt));
		f.getContentPane().add(BorderLayout.CENTER, broadcastRandom);
		f.getContentPane().add(BorderLayout.SOUTH, broadcastAll);
		f.pack();
		f.setVisible(true);
	}

	@Override
	public void act(ActionExec action, List<ActionExec> feedback) {
		if (action.getActionTerm().getFunctor().startsWith("tell_agents")) {
			this.agentList = new ArrayList<String>();
			for(Term term :action.getActionTerm().getTerms())
			{
				agentList.add(term.toString());
			}
			action.setResult(true);
			feedback.add(action);

		} else {
			super.act(action,feedback); // send the action to the environment to be performed.
		}
	}


	private void addEdge(String node1, String node2, int cost)
	{

	}

	private void removeEdge(String node1, String node2)
	{

	}

	@Override
	public void stop() {
		f.dispose();
		super.stop();
	}
}
