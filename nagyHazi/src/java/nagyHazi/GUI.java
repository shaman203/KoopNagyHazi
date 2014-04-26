package nagyHazi;


import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;
import jason.architecture.*;
import jason.asSemantics.ActionExec;
import jason.asSyntax.Term;

import javax.swing.*;


public class GUI extends AgArch {

	JTextArea jt;
	JFrame    f;
	JButton broadcastRandom;
	JButton broadcastAll;

	

	public GUI() {
		jt = new JTextArea(10, 30);
		jt.setEditable(false);
		broadcastRandom = new JButton("Broadcast random info");
		broadcastRandom.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {

				

				broadcastAll.setEnabled(false);
				broadcastRandom.setEnabled(false);
			}
		});

		broadcastAll = new JButton("Broadcast all info");
		broadcastAll.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
/*
				for(int i=1;i<=premiseCount;i++)
				{
					Literal goal = ASSyntax.createLiteral("broadcast",ASSyntax.createNumber(i));
					getTS().getC().addAchvGoal(goal, null);
				}
*/
				broadcastAll.setEnabled(false);
				broadcastRandom.setEnabled(false);
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
			for(Term term :action.getActionTerm().getTerms())
			{
				System.out.println(term.toString());
			}
			action.setResult(true);
			feedback.add(action);

			broadcastRandom.setEnabled(true);
			broadcastAll.setEnabled(true); // enable GUI button
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
